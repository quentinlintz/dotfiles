# ─── path ─────────────────────────────────────────────────────────────────────
# Homebrew itself is set up in .zprofile (login shells).
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# mise manages the Go toolchain but does not set GOPATH; keep it explicit so the
# workspace stays at ~/.local/go rather than reverting to ~/go.
export GOPATH="$HOME/.local/go"

export EDITOR="nvim"
export EZA_CONFIG_DIR="$HOME/.config/eza"

# ─── completion ───────────────────────────────────────────────────────────────
fpath=("$(brew --prefix)/opt/eza/share/zsh/site-functions" $fpath)

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

# ─── history ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
setopt AUTO_CD INTERACTIVE_COMMENTS NO_BEEP

# ─── plugins (Homebrew, no framework) ─────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6e6a86'
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Must be sourced last of the two: it wraps every widget defined before it.
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


# ─── aliases ──────────────────────────────────────────────────────────────────
alias c='clear'
alias cat='bat'
alias h='tldr'          # not `man`: tldr answers "how do I tar", nothing else
alias mkdir='mkdir -p'
alias ff='fastfetch'

alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree --level=2'

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias v='nvim'
alias g='git'
alias lg='lazygit'
alias ldk='lazydocker'

# ─── tools ────────────────────────────────────────────────────────────────────
# Rose Pine Moon
export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:#232136,hl:#ea9a97
  --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
  --color=border:#44415a,header:#3e8fb0,gutter:#232136
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
  --height=40% --layout=reverse --border=rounded"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
source <(fzf --zsh)

# sesh: Ctrl-o opens the session picker. Inside tmux, C-b o is the same thing.
sesh-sessions() {
  local session
  session=$(sesh list --icons | fzf --no-sort --ansi --prompt='session  ' \
    --preview-window 'right:55%' --preview 'sesh preview {}') || return 0
  [[ -z $session ]] && return 0
  zle reset-prompt >/dev/null 2>&1 || true
  sesh connect "$session"
}
zle -N sesh-sessions
bindkey '^o' sesh-sessions

# yazi: `y` browses, and leaves the shell in whatever directory you quit from.
# Plain `yazi` does not do this: the cwd dies with the child process.
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [[ -n $cwd && $cwd != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

eval "$(starship init zsh)"

command -v mise >/dev/null && eval "$(mise activate zsh)"

# atuin owns Ctrl-R and Up. It replaces the zsh history-search bindkeys that
# used to live in the plugins block; keeping both meant two different histories
# answering the same key. --disable-up-arrow is deliberately not passed: Up
# searching within the current directory is the reason to run it at all.
eval "$(atuin init zsh)"

# zoxide must be initialized last so its chpwd hook isn't clobbered.
# _ZO_DOCTOR=0 silences a false positive in non-interactive shells (e.g. Claude
# Code's snapshot) that restore functions without chpwd_functions.
export _ZO_DOCTOR=0
eval "$(zoxide init zsh)"
alias cd='z'
