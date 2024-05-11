if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=~/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
source $ZSH/oh-my-zsh.sh
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug load

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

. /opt/homebrew/opt/asdf/libexec/asdf.sh
[ -s "/Users/quentinlintz/.bun/_bun" ] && source "/Users/quentinlintz/.bun/_bun"

export PATH="$PATH:/Users/quentinlintz/.local/bin"
alias vi=nvim
