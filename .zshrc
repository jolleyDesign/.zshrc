## for macOS

# adjusting history files & size
HISTFILE=~/.config/.histfile
HISTSIZE=1000
SAVEHIST=10000

# autocd for zsh
setopt autocd

# custom aliases
alias x='exit'

# Easier navigation 
alias ..='z ..'
alias ...='z ../..'
alias .3='z ../../..'
alias .4='z ../../../..'
alias cd='z'
alias l='lsd -la'
alias ls="lsd -la"
alias cdw='z ~/dev'
alias cda='z ~/.archive'

# Random aliases
alias cat='bat'
alias ff='fzf'
alias g='git'
alias h='history'
alias cl='clear'

# Starting my penpot docker instance
alias penpot-start='sudo docker compose -p penpot -f docker-compose.yaml up -d'
alias penpot-stop='sudo docker compose -p penpot -f docker-compose.yaml down'

# Quick launching of dotfiles
alias zed="code ~/.zshrc"
alias ged='code ~/.config/ghostty/config'
alias explore='xdg-open'

# Launching GUI apps
alias vc='code'

# function for quick opening yazi, and auto cd'ing into directory
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# function for archiving files instead of deleting them
# adds a random number to the end to try and prevent duplicate filenames  
archive() {
    if [ ! -d ~/.archive ]; then
        read "answer?~/.archive doesn't exist. Create it? (y/n) "
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            mkdir -p ~/.archive
            echo "Created ~/.archive"
        else
            echo "Aborted."
            return 1
        fi
    fi

    sudo mv -i "$1" ~/.archive/"$1-archive-$RANDOM"
    echo "Sent the following to ~/.archive: $1"
}


# function for updating packages (pacman & yay)
# update() {
#   sudo pacman -Syu --noconfirm
#   yay -Syu --noconfirm
# }

# function for installing a single font in Gnome
## add-font() {
##   mv -v -t $1 ~/.local/share/fonts/
##   echo "Font is installed!"
## }

# function for installing a folder of fonts in Gnome
## add-font-folder() {
##   mv $1/* ~/.local/share/fonts/
##   echo "Fonts are installed!"
## }

# script for sending videos to the local media server
function send() {
  local source="$1"

  if [[ -z "$source" ]]; then
    echo "Usage: send <file_or_folder>"
    return 1
  fi

  echo "Where do you want to send it?"
  echo "  1) Movies"
  echo "  2) Shows"
  echo "  3) Music"
  read -r "choice?Choice [1-3]: "

  local dest_path
  case "$choice" in
    1) dest_path="/mnt/media/movies" ;;
    2) dest_path="/mnt/media/shows" ;;
    3) dest_path="/mnt/media/music" ;;
    *)
      echo "Invalid choice. Aborting."
      return 1
      ;;
  esac

  local user="jolley"
  local host="192.168.0.200"

  echo "Sending to $user@$host:$dest_path ..."
  scp -r "$source" "$user@$host:$dest_path/"
}

# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Copy a file in-place with a datestamp suffix
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
    echo "Backed up $1"
}

# Universal un-archiver
extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.tar.gz|*.tgz)    tar xzf "$1"    ;;
        *.tar.bz2|*.tbz2)  tar xjf "$1"    ;;
        *.tar.xz)          tar xJf "$1"    ;;
        *.tar)             tar xf "$1"     ;;
        *.zip)             unzip "$1"      ;;
        *.gz)              gunzip "$1"     ;;
        *.bz2)             bunzip2 "$1"    ;;
        *.xz)              unxz "$1"       ;;
        *.rar)             unrar x "$1"    ;;
        *.7z)              7z x "$1"       ;;
        *.Z)               uncompress "$1" ;;
        *)  echo "Don't know how to extract '$1'" ; return 1 ;;
    esac

    echo "Extracted: $1"
}

# Spin up a local HTTP server in the current directory
serve() {
    local port="${1:-8000}"
    echo "Serving $(pwd) at http://localhost:$port"
    if command -v python3 &>/dev/null; then
        python3 -m http.server "$port"
    elif command -v python &>/dev/null; then
        python -m SimpleHTTPServer "$port"
    else
        echo "Python not found — can't start server"
        return 1
    fi
}

# Reload shell config
reload() {
    if [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc && echo "Reloaded ~/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        source ~/.bashrc && echo "Reloaded ~/.bashrc"
    else
        echo "Unknown shell — reload manually"
    fi
}

# Print PATH entries one per line
path() {
    echo "$PATH" | tr ':' '\n'
}

# Quick weather forecast
weather() {
    local location="${1:-}"
    curl -s "wttr.in/${location}?format=3" 2>/dev/null \
        || echo "Couldn't reach wttr.in — check your connection"
}

# Added by Antigravity
export PATH="/Users/jolley/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

eval "$(starship init zsh)"

# setting zoxide
eval "$(zoxide init zsh)"
