# dotfiles

Configuration for **silver**: MacBook Pro (M4), macOS Tahoe, Ghostty + zsh.
The working environment is terminal-native: tmux drives the panes, Neovim is the
editor, and Claude Code runs in a pane beside it.

Everything is themed [Rosé Pine Moon](https://rosepinetheme.com). Configs are
symlinked into place by `install.sh`; there is no `stow` dependency.

The shell has no framework. Neovim does: it runs [LazyVim](https://lazyvim.org),
on purpose. The keymap vocabulary was already muscle memory, and that is worth
more than a config small enough to read in one sitting. `lua/plugins/` holds the
handful of overrides where LazyVim's defaults disagree with what CI enforces,
plus `trim.lua`, which turns off the five plugins something else here already
does.

**The working pattern is written down in [`docs/pattern.md`](docs/pattern.md),
and `C-b ?` renders it in a popup.** Three ideas: Space is the leader at every
scope, panes are for things you watch while popups are for things you do, and
every long-running agent gets its own worktree and window.

## Install

```sh
git clone <repo-url> ~/workspace/dotfiles
cd ~/workspace/dotfiles
./install.sh --dry-run    # inspect first
./install.sh
```

The installer is idempotent: re-run it any time. It backs up anything it
replaces to `~/.dotfiles-backup/<timestamp>/` rather than overwriting, and
prunes symlinks left behind by configs you've since deleted.

Five things stay manual, because they change state beyond dotfiles:

```sh
./macos.sh          # system preferences (keyboard, Finder, Dock, screenshots)
gh auth login       # credentials go to the macOS keychain, never to this repo
mise install        # language runtimes from config/mise/config.toml
atuin import auto   # seed the history database from ~/.zsh_history, once
exec zsh
```

## Layout

```
config/     → ~/.config/<name>       auto-discovered, one symlink each
home/       → ~/<name>               .zshrc, .zprofile
bin/        → ~/.local/bin/<name>    helper scripts the tmux bindings call
apps/       → app-specific paths     Claude Code settings and themes
docs/       the working pattern, rendered by C-b ?
Brewfile                             packages and casks
install.sh                           the linker
macos.sh                             defaults write …
```

## What's tracked

| | |
|---|---|
| **shell** | zsh: no framework, Homebrew plugins, starship prompt |
| **terminal** | ghostty |
| **multiplexer** | tmux: no tpm, hand-rolled status line and which-key menu; `sesh` for sessions |
| **editor** | Neovim + LazyVim; overrides in `config/nvim/lua/plugins/` |
| **agent** | Claude Code in the pane beside the editor; `claudecode.nvim` bridges the two |
| **git** | `config/git/` (XDG, not `~/.gitconfig`), gh CLI, delta, difftastic |
| **runtimes** | mise, including the Go tool belt (gopls, dlv, gotestsum) |
| **cli** | bat, eza, fzf, zoxide, atuin, yazi, btop, fastfetch |

There is no GUI editor. The base carries no language beyond Go; adding one is
two lines, and `docs/pattern.md` records the shape.

## Adding a config

Drop it in `config/` and re-run. `install.sh` iterates `config/*`, so a new
tool needs no change to the script:

```sh
mv ~/.config/newthing config/newthing
./install.sh
git add config/newthing && git commit -m "Add newthing config"
```

For a path outside `~/.config`, add one `link` line in `install.sh`.

After installing a package:

```sh
brew bundle dump --force
```

## Theme

`config/` carries the palette in twelve places. If you retheme, these are the
files to touch:

| File | Notes |
|---|---|
| `config/ghostty/config` | `theme = Rose Pine Moon`, ships with Ghostty |
| `config/starship.toml` | palette defined in `[palettes.rose_pine_moon]` |
| `config/btop/themes/*.theme` | vendored |
| `config/bat/themes/*.tmTheme` | vendored; bat keys it by **filename** |
| `config/eza/theme.yml` | |
| `config/fastfetch/config.jsonc` | raw ANSI; escapes must be written `\u001b`, not a literal ESC byte (invalid JSON) |
| `home/.zshrc` | `FZF_DEFAULT_OPTS`, `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` |
| `config/nvim/lua/plugins/colorscheme.lua` | `variant = "moon"`, set as LazyVim's `colorscheme` |
| `config/tmux/tmux.conf` | raw hex in the status line block and the which-key menu title |
| `config/atuin/themes/*.toml` | keyed by semantic role, not UI element |
| `config/yazi/theme.toml` | `[mgr]`, not `[manager]` (renamed upstream) |
| `apps/claude/themes/*.json` | Claude Code's own `base` + `overrides` schema |

`git-delta` is the exception: it reads bat's theme registry, so the vendored
`config/bat/themes/rose-pine-moon.tmTheme` already colors every git diff.

```
base #232136   surface #2a273f   overlay #393552
muted #6e6a86  subtle  #908caa   text    #e0def4
love #eb6f92   gold    #f6c177   rose    #ea9a97
pine #3e8fb0   foam    #9ccfd8   iris    #c4a7e7
```

## Notes

- **Neovim bootstraps itself.** `lua/config/lazy.lua` clones lazy.nvim on first
  launch, so `install.sh` has nothing to do. `lazy-lock.json` pins every
  revision and is tracked. Parsers need the `tree-sitter-cli` brew; the
  `tree-sitter` formula is the library only and ships no binary.
- **Two package managers, split on one rule: does the version have to match
  CI?** mise owns the Go toolchain, mason owns everything else, and
  `lua/plugins/go.lua` stops mason installing a second copy. Launch `nvim` from
  a shell so it inherits mise's PATH.
- **`trim.lua` disables six LazyVim plugins.** `nui.nvim` has to be named
  explicitly: it looks like a noice dependency but LazyVim declares it
  standalone, so disabling noice alone leaves it installed.
- **The tmux bindings call `bin/` scripts by absolute path.** The tmux server
  inherits PATH from whichever shell first started it, which may never have run
  `.zshrc`.
- **`claudecode.nvim` runs with `provider = "none"`** and drives the Claude in
  the next pane rather than opening its own. It is deliberately **not lazy**:
  its job is to have a WebSocket server and a `~/.claude/ide/<port>.lock` file
  on disk *before* `claude --ide` starts next door, since that file is how
  claude finds the editor. Loading it on first keypress is too late: claude has
  already looked and given up. `C-b G` passes `--ide` for the same reason.
- **atuin owns Ctrl-R and Up**, which is why the zsh `history-search-*`
  bindkeys are gone. Local only: no account, no sync, no daemon.
- **TERM is deliberately unset** in the Ghostty config. If a remote host doesn't
  know `xterm-ghostty`: `infocmp -x | ssh <host> -- tic -x -`.
- **bat caches compiled themes.** `install.sh` runs `bat cache --build`; do it
  by hand after editing a `.tmTheme`.
- **Postgres is pinned to a major on purpose.** An unpinned `postgresql` moves
  majors on `brew upgrade` and silently leaves the old data directory behind.
  Migrating majors means a dump and restore, not just a version bump.
- **OrbStack, not Docker Desktop.** It provides the `docker` CLI itself, which
  is why the `docker` formula is not in the Brewfile. `.zprofile` and
  `home/.ssh/config` both carry an OrbStack include.
- `config/gh/hosts.yml` is gitignored because gh rewrites it constantly and the token
  lives in the keychain, not the file.
