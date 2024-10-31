eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json')"

plugins=(
  git
  asdf
  zsh-syntax-highlighting
  zsh-autosuggestions
)

fastfetch

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
export GOPATH=$HOME/.local/go

alias ls='eza --grid --icons'
alias ll='eza --icons -l'
alias vi='nvim'
alias z='zellij'
alias ff='fastfetch'
alias spotify='spt'
alias wt='wthrr -f d,w'

. /opt/asdf-vm/asdf.sh

# Fuzzy find things
source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

export FPATH=$FPATH:/tools/eza/completions/zsh
export PATH=$PATH:/home/quentin/.spicetify:$GOPATH/bin

