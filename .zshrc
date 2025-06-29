# custom prompt
PROMPT="%F{7}[%f%F{14}%n%f@%F{208}%~%f%F{7}]%f "

# adjusting history files & size
HISTFILE=~/.config/.histfile
HISTSIZE=1000
SAVEHIST=10000

# autocd for zsh
setopt autocd

# custom aliases
alias x='exit'
alias ll='ls -lah'
alias ee='sudo gedit'
alias explore='xdg-open'
alias sai='sudo apt install'
alias cdw='cd ~/dev'
alias h='history'
alias cl='clear'
alias vc='code'

# function for quick opening yazi, and auto cding into directory
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# function for archiving files instead of deleting them
# adds a random number to the end to prevent duplicate filenames  
archive() {
    sudo mv -i $1 ~/.archive/"$1-archive-$RANDOM"
}

# linking to syntax highlighting script
source ~/tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
