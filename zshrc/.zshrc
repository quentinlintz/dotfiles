. $HOME/.asdf/asdf.sh

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

alias vi=nvim
alias ff=fastfetch

eval "$(starship init zsh)"
