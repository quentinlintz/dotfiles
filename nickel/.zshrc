export STARSHIP_CONFIG=~/.config/starship/starship.toml

alias n="nvim"
alias ff="fastfetch"
alias cd="z"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(~/.local/bin/mise activate zsh)"
