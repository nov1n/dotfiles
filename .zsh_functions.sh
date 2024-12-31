#!/usr/bin/env bash

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

# Convert video to gif file.
# Usage: video2gif video_file (scale) (fps)
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}

function journal() {
  nvim +'ObsidianToday' '+ZenMode' -c 'sleep 100m' -c 'normal! G' -c 'normal! 2o' -c 'startinsert'

  # TODO: Replace with Rust client
  if
    printf "\n"
    curl -s --location 'http://portainer.carosi.nl:7440/api/v1/habits/35da0e/completions' \
      --header "Authorization: Bearer $BEAVER_TOKEN" \
      --header "Content-Type: application/json" \
      --output /dev/null \
      --data "{\"date_fmt\": \"%d-%m-%Y\", \"date\": \"$(date +'%d-%m-%Y')\", \"done\": true}"
  then
    echo "Habit completion logged successfully."
  fi
}

# BEGIN zsh-vi-mode patch: https://github.com/jeffreytse/zsh-vi-mode/issues/19#issuecomment-1915625381
my_zvm_vi_yank() {
  zvm_vi_yank
  echo -en "${CUTBUFFER}" | pbcopy
}

my_zvm_vi_delete() {
  zvm_vi_delete
  echo -en "${CUTBUFFER}" | pbcopy
}

my_zvm_vi_change() {
  zvm_vi_change
  echo -en "${CUTBUFFER}" | pbcopy
}

my_zvm_vi_change_eol() {
  zvm_vi_change_eol
  echo -en "${CUTBUFFER}" | pbcopy
}

my_zvm_vi_substitute() {
  zvm_vi_substitute
  echo -en "${CUTBUFFER}" | pbcopy
}

my_zvm_vi_substitute_whole_line() {
  zvm_vi_substitute_whole_line
  echo -en "${CUTBUFFER}" | pbcopy
}

my_zvm_vi_put_after() {
  CUTBUFFER=$(pbpaste)
  zvm_vi_put_after
  zvm_highlight clear # zvm_vi_put_after introduces weird highlighting
}

my_zvm_vi_put_before() {
  CUTBUFFER=$(pbpaste)
  zvm_vi_put_before
  zvm_highlight clear # zvm_vi_put_before introduces weird highlighting
}

my_zvm_vi_replace_selection() {
  CUTBUFFER=$(pbpaste)
  zvm_vi_replace_selection
  echo -en "${CUTBUFFER}" | pbcopy
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
