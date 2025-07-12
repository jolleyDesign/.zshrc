# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
alias ..='z ..'
alias ...='z ../..'
alias .3='z ../../..'
alias .4='z ../../../..'

alias cd='z'

alias cat='bat'

alias l='ls -lah --color=auto'

alias ff='fzf'
alias g='git'


alias ee='sudo gedit'
alias explore='xdg-open'
alias sai='sudo apt install'
alias cdw='cd ~/dev'
alias h='history'
alias cl='clear'
alias vc='code'
alias cda='cd ~/.archive'
alias zed="code ~/.zshrc"
alias penpot-start='sudo docker compose -p penpot -f docker-compose.yaml up -d'
alias penpot-stop='sudo docker compose -p penpot -f docker-compose.yaml down'
alias ged='code ~/.config/ghostty/config'
alias hed='code ~/.config/hypr/hyprland.conf'

alias fig='figma-linux'
alias fonts='gnome-font-viewer'

alias batocera="ssh root@batocera.local"

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
    echo "Sent the following to ~/.archive: $1"
}

# linking to syntax highlighting script
source ~/tools/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/tools/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

web2app() {
  if [ "$#" -ne 3 ]; then
    echo "Usage: web2app <AppName> <AppURL> <IconURL> (IconURL must be in PNG -- use https://dashboardicons.com)"
    return 1
  fi

  local APP_NAME="$1"
  local APP_URL="$2"
  local ICON_URL="$3"
  local ICON_DIR="$HOME/.local/share/applications/icons"
  local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
  local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

  mkdir -p "$ICON_DIR"

  if ! curl -sL -o "$ICON_PATH" "$ICON_URL"; then
    echo "Error: Failed to download icon."
    return 1
  fi

  cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=chromium --new-window --ozone-platform=wayland --app="$APP_URL" --name="$APP_NAME" --class="$APP_NAME"
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true
EOF

  chmod +x "$DESKTOP_FILE"
}

web2app-remove() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: web2app-remove <AppName>"
    return 1
  fi

  local APP_NAME="$1"
  local ICON_DIR="$HOME/.local/share/applications/icons"
  local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
  local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

  rm "$DESKTOP_FILE"
  rm "$ICON_PATH"
}

# function for updating packages
update() {
  sudo pacman -Syu --noconfirm
  yay -Syu --noconfirm
}

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# functions for installing fonts
add-font() {
  mv -v -t $1 ~/.local/share/fonts/
  echo "Font is installed!"
}

add-font-folder() {
  mv $1/* ~/.local/share/fonts/
  echo "Fonts are installed!"
}

# Display Lomarchy hotkeys in the terminal
hotkeys() {
  echo "---Navigation hotkeys---"
  echo "Super + Space: app launcher"
  echo "Super + W: close focused window"
  echo "Super + 1/2/3/4: jump to a workspace"
  echo "Shift + Super + 1/2/3/4: move window to workspace"
  echo "Ctrl + 1/2/3/...: jump to browser tab"
  echo "F11: go full screen on focused window"
  echo "Super + Arrow: move focus to another window"
  echo "Super + Shift + Arrow: swap window positions"
  echo "Super + Equal: grow focused window to the left"
  echo "Super + Minus: grow focused window to the right"
  echo "Super + Shift + Equal: grow focused window to the bottom"
  echo "Super + Shift + Minus: grow focused window to the top"
  echo ""
  echo "---Launching apps---"
  echo "Super + Enter (return): terminal"
  echo "Super + B: default browser"
  echo "Super + F: file manager"
  echo "Super + T: activity monitor (btop)"
  echo "Super + M: Spotify"
  echo "Super + Print Screen: color picker"
  echo "Super + Ctrl + V: clipboard manager"
  echo ""
  echo "---Appearance---"
  echo "Ctrl + Shift + Super + Space: next theme"
  echo "Ctrl + Super + Space: next background image"
  echo "Shift + Super + Space: show or hide the top bar (waybar)"
  echo ""
  echo "---System---"
  echo "Super + Escape: lock computer"
  echo "Shift + Super + Escape: put computer to sleep"
  echo "Ctrl + Super + Escape: restart computer"
  echo "Ctrl + Shift + Super + Escape: shutdown computer"
  echo "Alt + Super + Escape: restart Hyprland"
  echo ""
  echo "---Within file manager---"
  echo "Ctrl + L: go to path"
  echo "Space: preview file"
  echo "Backspace: go back one directory"
  echo ""
  echo "---Screenshots---"
  echo "Print Screen: screenshot of a region"
  echo "Shift + Print Screen: screenshot a window"
  echo "Ctrl + Print Screen: screenshot an entire monitor"
}

eval "$(zoxide init zsh)"
# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/jolley/.lmstudio/bin"
# End of LM Studio CLI section

function stb-media() {
  scp -r $1 root@batocera.local:/media/emulation/batocera/kodi
}

# function stb-games() {
#   $system

#   case $system in
#     "n64")
#       $system="n64"
#       ;;
#     "gba")
#       $system="gba"
#       ;;
#     "gba")
#       $system="gbc"
#       ;;
#     "gamecube")
#       $system="gamecube"
#       ;;
#     "nds")
#       $system="nds"
#       ;;
    
#   "scp -r $1 root@batocera.local:/media/emulation/$system"
# }
