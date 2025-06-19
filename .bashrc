#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ff='fastfetch'
alias up='sudo pacman -Syu'
alias v='nvim'
alias ping='ping -c3'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
eval "$(zoxide init bash)"

HISTFILE=~/.bash_history
HISTSIZE=10000
SAVEHIST=10000

export PROMPT_COMMAND='history -a; history -r'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
