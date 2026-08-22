#!/usr/bin/env bash
#
# Idempotent dotfiles installer. Safe to re-run.
#
#   ./install.sh            apply
#   ./install.sh --dry-run  show what would happen, touch nothing
#
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY=false
[[ ${1:-} == "--dry-run" ]] && DRY=true

$DRY && echo "── DRY RUN: nothing will be modified ──"

# ── linker ────────────────────────────────────────────────────────────────────
# Handles the three cases a bare `ln -sfn` gets wrong:
#   1. dst is already the correct symlink   -> no-op
#   2. dst is a *different* symlink         -> replace
#   3. dst is a real file OR real directory -> back up, then replace
#      (`ln -sfn` would silently create the link *inside* a real directory)
link() {
  local src="$REPO/$1" dst="$2" rel

  if [[ ! -e $src ]]; then
    echo "MISSING  $src" >&2
    return 1
  fi

  if [[ -L $dst ]]; then
    if [[ $(readlink "$dst") == "$src" ]]; then
      echo "ok       ${dst/#$HOME/\~}"
      return 0
    fi
    $DRY || rm "$dst"
  elif [[ -e $dst ]]; then
    rel="${dst#"$HOME"/}"
    echo "backup   ${dst/#$HOME/\~}  ->  ${BACKUP/#$HOME/\~}/$rel"
    if ! $DRY; then
      mkdir -p "$(dirname "$BACKUP/$rel")"
      mv "$dst" "$BACKUP/$rel"
    fi
  fi

  $DRY || { mkdir -p "$(dirname "$dst")"; ln -s "$src" "$dst"; }
  echo "link     ${dst/#$HOME/\~}  ->  ${src/#$HOME/\~}"
}

# Remove symlinks that point into this repo but no longer resolve, i.e. configs
# deleted from the repo since the last run. Scans every directory this script
# links into; a link left somewhere else (VS Code's settings.json used to live
# under ~/Library) has to be cleaned up by hand.
prune() {
  local l
  while IFS= read -r l; do
    [[ $(readlink "$l") == "$REPO"/* ]] || continue
    [[ -e $l ]] && continue
    echo "prune    ${l/#$HOME/\~}  (dangling)"
    $DRY || rm "$l"
  done < <(find "$HOME" -maxdepth 1 -type l
           find "$HOME/.config" -maxdepth 1 -type l 2>/dev/null
           find "$HOME/.local/bin" -maxdepth 1 -type l 2>/dev/null
           find "$HOME/.claude" -maxdepth 1 -type l 2>/dev/null)
}

# ── 1. homebrew ───────────────────────────────────────────────────────────────
if ! command -v brew >/dev/null; then
  echo "==> Installing Homebrew"
  $DRY || /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> Installing packages from Brewfile"
# NB: must be an if/else. `$DRY && check || install` falls through to the
# install whenever check exits non-zero, which is exactly when deps are
# missing, i.e. a dry run would install for real.
if $DRY; then
  brew bundle check --file "$REPO/Brewfile" || true
else
  # Non-fatal on purpose. A cask can fail for reasons that have nothing to do
  # with this repo: it wants sudo, a font is mid-upgrade, the network is out.
  # Linking must not be hostage to that.
  brew bundle install --file "$REPO/Brewfile" \
    || echo "!! brew bundle had failures, continuing to link" >&2
fi

# ── 2. symlinks ───────────────────────────────────────────────────────────────
echo "==> Linking"

# Everything under config/ maps 1:1 into ~/.config, so there is no table to maintain.
$DRY || mkdir -p "$HOME/.config"
for path in "$REPO"/config/*; do
  link "config/$(basename "$path")" "$HOME/.config/$(basename "$path")"
done

link home/.zshrc            "$HOME/.zshrc"
link home/.zprofile         "$HOME/.zprofile"

# ssh refuses to use a config in a world-writable directory, and link() creates
# parents with the default umask. No private keys are tracked; this is host
# aliases only.
$DRY || { mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"; }
link home/.ssh/config       "$HOME/.ssh/config"
link apps/claude/settings.json "$HOME/.claude/settings.json"
link apps/claude/themes        "$HOME/.claude/themes"

# Helper scripts the tmux bindings call. They are referenced by absolute path in
# tmux.conf rather than by name: the tmux server inherits its PATH from whatever
# shell first started it, which is not guaranteed to have run .zshrc.
$DRY || mkdir -p "$HOME/.local/bin"
for path in "$REPO"/bin/*; do
  link "bin/$(basename "$path")" "$HOME/.local/bin/$(basename "$path")"
done

prune

# ── 3. post-install ───────────────────────────────────────────────────────────
echo "==> Building bat theme cache"
$DRY || bat cache --build >/dev/null

cat <<EOF

Done.$([[ -d $BACKUP ]] && echo "  Replaced files are in ${BACKUP/#$HOME/\~}")

Still manual:
  ./macos.sh                                  system preferences
  gh auth login                               GitHub credentials (keychain)
  mise install                                language runtimes
  atuin import auto                           seed shell history, once
  exec zsh                                    reload the shell
EOF
