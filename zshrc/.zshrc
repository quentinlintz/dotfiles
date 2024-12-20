plugins=(
  git
  asdf
  archlinux
  zsh-syntax-highlighting
  zsh-autosuggestions
)

fastfetch

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export PATH=$PATH:/home/quentin/.local/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/.cargo/bin
export FPATH=$FPATH:/tools/eza/completions/zsh
alias ls='eza --grid --icons'
alias ll='eza --icons -l'
alias vi='nvim'
alias ff='fastfetch'

. ~/.asdf/asdf.sh

eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json')"
