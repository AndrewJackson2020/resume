if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux
fi
export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

export EDITOR="nvim"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:~/.config/emacs/bin/
export PATH=$PATH:~/.local/go/bin/
export PATH=$PATH:~/go/bin/

FZF_CTRL_T_COMMAND= eval "$(fzf --zsh)"
eval "$(starship init zsh)"

alias rm='rm -i'
alias ls='eza'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias ps='procs'
alias du='dust'

autoload -U compinit; compinit
source ~/.fzf-tab/fzf-tab.plugin.zsh
