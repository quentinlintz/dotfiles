plugins=(
  git
  asdf
  zsh-syntax-highlighting
  zsh-autosuggestions
)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
export GOPATH=$HOME/.local/go

alias vi=nvim
alias ff=fastfetch

eval "$(starship init zsh)"
