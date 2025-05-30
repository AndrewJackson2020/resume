
export EDITOR="nvim"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:~/.config/emacs/bin/
export PATH="$HOME/.local/go/bin::$PATH"

FZF_CTRL_T_COMMAND= eval "$(fzf --bash)"

alias rm='rm -i'
alias ls='eza'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias ps='procs'
alias du='dust'


if [ "${TERM}" == 'alacritty' ]; then
    zsh
fi
