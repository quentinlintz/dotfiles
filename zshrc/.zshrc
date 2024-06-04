. /opt/homebrew/opt/asdf/libexec/asdf.sh

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

alias ls=colorls
alias vi=nvim

eval "$(starship init zsh)"
