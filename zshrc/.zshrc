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

eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_macchiato.omp.json')"
