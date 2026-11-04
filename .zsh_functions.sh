#!/usr/bin/env zsh

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_"
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')"
}

# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  sleep 1 && open "http://localhost:${port}/" &
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# Run `dig` and display the most useful info
function digga() {
  dig +nocmd "$1" any +multiline +noall +answer
}

# credit: http://nparikh.org/notes/zshrc.txt
# Usage: extract <file>
# Description: extracts archived files / mounts disk images
# Note: .dmg/hdiutil is Mac OS X-specific.
function extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar -jxvf $1 ;;
      *.tar.gz) tar -zxvf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.dmg) hdiutil mount $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar -xvf $1 ;;
      *.tbz2) tar -jxvf $1 ;;
      *.tgz) tar -zxvf $1 ;;
      *.zip) unzip $1 ;;
      *.ZIP) unzip $1 ;;
      *.pax) cat $1 | pax -r ;;
      *.pax.Z) uncompress $1 --stdout | pax -r ;;
      *.Z) uncompress $1 ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

upgrade() {
  topgrade \
    && brew cleanup --prune=all \
    && brew doctor \
    && docker system prune -f
  alerter --title "Upgrade" --message "Done" &
}

cdtemp() {
  cd "$(mktemp -d)" || exit
}

y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

cd() {
  z "$@"
  # Ghostty's shell-integration (cursor,sudo,title) emits OSC 7 automatically.
  # Inside tmux, also rename the current window to the basename of PWD.
  if [[ -n "$TMUX" ]]; then
    tmux rename-window "$(basename "$PWD")"
  fi
}

ssh() {
  local host="$1"
  if [[ -n "$TMUX" ]]; then
    tmux rename-window "ssh:$host"
    command ssh "$@"
    tmux rename-window "$(basename "$PWD")"
  else
    printf '\e]0;ssh:%s\a' "$host"
    command ssh "$@"
  fi
}

dsh() {
  docker exec -it $1 bash
}
# Completion function for `dsh`
_dsh() {
  local state

  _arguments \
    '1:container name:->containers'

  case $state in
    containers)
      # Use Docker to get the list of running container names
      local containers=("${(@f)$(docker ps --format '{{.Names}}')}")
      compadd "$@" -- "${containers[@]}"
      ;;
  esac
}
# Register the completion function with `dsh`
compdef _dsh dsh

# Fuzzy search and select docker context using fzf
dctx() {
  local selected_context
  selected_context=$(docker context ls --format '{{.Name}}' | fzf --height=40% --reverse --prompt="Select docker context: ")

  if [[ -n "$selected_context" ]]; then
    docker context use "$selected_context"
  fi
}

# Convert video to gif file.
# Usage: video2gif video_file (scale) (fps)
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}

# BEGIN zsh-vi-mode patch: https://github.com/jeffreytse/zsh-vi-mode/issues/19#issuecomment-1915625381
if [[ $(uname) = "Darwin" ]]; then
  on_mac_os=0
else
  on_mac_os=1
fi

cbread() {
  if [[ $on_mac_os -eq 0 ]]; then
    pbcopy
  else
    xclip -selection primary -i -f | xclip -selection secondary -i -f | xclip -selection clipboard -i
  fi
}

cbprint() {
  if [[ $on_mac_os -eq 0 ]]; then
    pbpaste
  else
    if x=$(xclip -o -selection clipboard 2>/dev/null); then
      echo -n $x
    elif x=$(xclip -o -selection primary 2>/dev/null); then
      echo -n $x
    elif x=$(xclip -o -selection secondary 2>/dev/null); then
      echo -n $x
    fi
  fi
}

nvim-dir() {
  if [ $# -lt 1 ]; then
    echo "Usage: nvim-dir /path/to/config [files...]"
    return 1
  fi

  # Expand first argument into an absolute path
  local config_dir
  config_dir="$(realpath "$1")"

  if [ ! -d "$config_dir" ]; then
    echo "Error: Config dir '$config_dir' does not exist"
    return 1
  fi

  # Use basename of dir as NVIM_APPNAME
  local appname
  appname="$(basename "$config_dir")"

  shift
  NVIM_APPNAME="$appname" XDG_CONFIG_HOME="$(dirname "$config_dir")" nvim "$@"
}

notify() {
  local command_text="$*"
  time "$@"
  local statuscode=$?
  printf "\e]9;%s\e\\" "Command '$command_text' finished with status code: $statuscode"
  afplay /System/Library/Sounds/Glass.aiff
}

# Override zsh-auto-notify's macOS notifier (defined by the antidote plugin)
# to use `alerter` (same tool squawk uses) with --app-icon so the notification
# carries Ghostty's icon instead of the generic Script Editor icon that plain
# `osascript display notification` shows. --sender (impersonation) silently
# drops the notification on modern macOS regardless of Ghostty's notification
# permission, so use --app-icon (just attaches an image, no impersonation).
# Clicking the notification body jumps back to the tmux pane the command ran
# in and activates Ghostty, same pattern as squawk's jump_to_pane.
_auto_notify_message() {
  local command="$1" elapsed="$2" exit_code="$3"

  if [[ "$exit_code" -eq 130 ]] && [[ "${AUTO_NOTIFY_CANCEL_ON_SIGINT}" -eq 1 ]]; then
    return
  fi

  local title body pane
  title="$(_auto_notify_format "${AUTO_NOTIFY_TITLE:-\"%command\" Completed}" "$command" "$elapsed" "$exit_code")"
  body="$(_auto_notify_format "${AUTO_NOTIFY_BODY:-Total time: %elapsed seconds}" "$command" "$elapsed" "$exit_code")"
  [[ -n "$TMUX" ]] && pane="$(tmux display-message -p '#{pane_id}' 2>/dev/null)"

  {
    local result kind
    result="$(alerter --title "$title" --message "$body" \
      --app-icon /Applications/Ghostty.app/Contents/Resources/Ghostty.icns \
      --actions "Jump" --timeout 30 --json 2>/dev/null)"
    kind="$(jq -r '.activationType // ""' <<<"$result" 2>/dev/null)"
    # The only action is "Jump", so any action/body click navigates, same as
    # squawk's notify().
    if [[ "$kind" == "actionClicked" || "$kind" == "contentsClicked" ]]; then
      [[ -n "$pane" ]] && tmux switch-client -t "$pane" 2>/dev/null
      osascript -e 'tell application id "com.mitchellh.ghostty" to activate' >/dev/null 2>&1
    fi
  } &|
}

my_zvm_vi_yank() {
  zvm_vi_yank
  echo -en "${CUTBUFFER}" | cbread
}

my_zvm_vi_delete() {
  zvm_vi_delete
  echo -en "${CUTBUFFER}" | cbread
}

my_zvm_vi_change() {
  zvm_vi_change
  echo -en "${CUTBUFFER}" | cbread
}

my_zvm_vi_change_eol() {
  zvm_vi_change_eol
  echo -en "${CUTBUFFER}" | cbread
}

my_zvm_vi_substitute() {
  zvm_vi_substitute
  echo -en "${CUTBUFFER}" | cbread
}

my_zvm_vi_substitute_whole_line() {
  zvm_vi_substitute_whole_line
  echo -en "${CUTBUFFER}" | cbread
}

my_zvm_vi_put_after() {
  CUTBUFFER=$(cbprint)
  zvm_vi_put_after
  zvm_highlight clear # zvm_vi_put_after introduces weird highlighting
}

my_zvm_vi_put_before() {
  CUTBUFFER=$(cbprint)
  zvm_vi_put_before
  zvm_highlight clear # zvm_vi_put_before introduces weird highlighting
}

my_zvm_vi_replace_selection() {
  CUTBUFFER=$(cbprint)
  zvm_vi_replace_selection
  echo -en "${CUTBUFFER}" | cbread
}

zvm_after_lazy_keybindings() {
  zvm_define_widget my_zvm_vi_yank
  zvm_define_widget my_zvm_vi_delete
  zvm_define_widget my_zvm_vi_change
  zvm_define_widget my_zvm_vi_change_eol
  zvm_define_widget my_zvm_vi_put_after
  zvm_define_widget my_zvm_vi_put_before
  zvm_define_widget my_zvm_vi_substitute
  zvm_define_widget my_zvm_vi_substitute_whole_line
  zvm_define_widget my_zvm_vi_replace_selection

  zvm_bindkey vicmd 'C' my_zvm_vi_change_eol
  zvm_bindkey vicmd 'P' my_zvm_vi_put_before
  zvm_bindkey vicmd 'S' my_zvm_vi_substitute_whole_line
  zvm_bindkey vicmd 'p' my_zvm_vi_put_after

  zvm_bindkey visual 'p' my_zvm_vi_replace_selection
  zvm_bindkey visual 'c' my_zvm_vi_change
  zvm_bindkey visual 'd' my_zvm_vi_delete
  zvm_bindkey visual 's' my_zvm_vi_substitute
  zvm_bindkey visual 'x' my_zvm_vi_delete
  zvm_bindkey visual 'y' my_zvm_vi_yank
}
# END zsh-vi-mode patch
