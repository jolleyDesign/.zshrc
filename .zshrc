## Custom .zshrc for Z-Shell by @jolley

# Setting custom history size and location
HISTFILE=~/.config/.histfile
HISTSIZE=1000
SAVEHIST=10000

# setting keybinding and autocd function 
setopt autocd
bindkey -e

# setting simple custom PS1 user prompt
PROMPT="%F{7}[%f%F{14}%n%f@%F{208}%~%f%F{7}]%f "

# custom PATH directories

# adding path for sbin directory
export PATH="$PATH:/sbin"
# adding path for android-studio
export PATH="$PATH:/home/jolley/tools/android-studio/bin/"
# adding path for .local env
export PATH="$PATH:/home/jolley/.local/bin"
# adding path for Golang
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$PATH:/home/jolley/golib"
# adding paths for pnpm
export PNPM_HOME="/home/jolley/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"



# defining auto/tab complete functions
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# run neofetch on startup, purely for looks...
neofetch

# - #
# user-defined aliases by @jolley
# - #

# easier and quicker exiting from terminal
alias x='exit'
# making it easier to open something in gedit
alias ee='sudo gedit'
# check NetworkManager status (quickly)
alias netstatus='sudo systemctl status NetworkManager'
# opens file explorer to directory
alias explore='xdg-open'
# expanding the ll operation
alias ll='ls -lah'
# alias for opening android studio
alias studio='studio.sh'


# setting custom functions

# macchanger, with disabling and re-enabling of the interface
# first argument should be interface identifier (ex: wlo1, wlan0)
randmac() {
    sudo ifconfig $1 down
    sudo macchanger -r $1
    sudo ifconfig $1 up
}


# PRIVatize network information
# prereqs: Private Internet Access cli (piactl) and macchanger
# randomizes mac address using my randmac() function, and enables PIA VPN
# verbose information on IP and Mac before and after changes made
# first argument should be interface identifier (ex: wlo1, wlan1)
PRIV() {
	
	if [ $1 == "help" ]; then
		echo "First argument should be interface identifier (ex: wlo1, wlan1, etc). No other arguments should be provided."
		return 0
	elif [ -z "$1" ]; then
		echo "First argument should be interface identifier (ex: wlo1, wlan1, etc). No other arguments should be provided."
		return 0
	fi

	echo "Current IP conf: "
	ifconfig $1 | grep inet
	piactl connect
	randmac $1
	echo "Getting new IP information: "
	sleep 4
	piactl get pubip && piactl get vpnip
	ifconfig $1 | grep inet
}


# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jolley/.zshrc'

autoload -Uz compinit
compinit

# adding ZSH syntax highlighting plugin, found on GitHub
# link to package: https://github.com/jolleyDesign/zsh-syntax-highlighting
source /home/jolley/tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
