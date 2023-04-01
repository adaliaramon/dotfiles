# autoload -U colors & colors
PS1="%F{33}%~ %f$ "

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

bindkey -v
function zle-line-init zle-keymap-select {
	if [[ $KEYMAP == vicmd ]]; then
		echo -ne '\e[2 q'
	elif [[ $KEYMAP == (main|viins) ]]; then
		echo -ne '\e[6 q'
	fi
}
zle -N zle-line-init
zle -N zle-keymap-select

autoload -Uz compinit
zstyle ":completion:*" menu select
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' completer _expand_alias _complete _ignored  # Expand aliases
compinit
_comp_options+=(globdots)  # Enable globbing of hidden files

source $HOME/.dotfiles/ls_colors
source /usr/share/fzf/key-bindings.zsh

alias bat="bat -p"
alias c="cd"
alias cal="cal -m"
alias cp="cp -r"
alias diff="git diff --no-index"
alias gd="git diff"
alias get-battery="cat /sys/class/power_supply/BAT1/capacity"
alias get-volume="amixer -M get Master"  # Requires alsa-utils
alias gl="git log"
alias grep="grep --color=auto"
alias gs="git -p status -vv"
alias htop="btm -ab"
alias l="ls --color=auto"
alias la="ls -A --color=auto"
alias pip="uv pip"
alias set-volume="amixer -M set Master"  # Requires alsa-utils
alias toggle-volume"amixer -M set Master toggle"  # Requires alsa-utils
alias update-pip="uv pip freeze | cut -d '=' -f 1 | grep -v 'nvidia\|-e\|@' | xargs -r uv pip install -U"
alias update-system="paru && paru -c && rustup update"
alias v="nvim"
alias xephyr="Xephyr -br -ac -noreset -screen 800x600 :1"
alias z="zathura --fork"
