#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Send video to Jellyfin
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📺
# @raycast.argument1 { "type": "text", "placeholder": "YouTube URL", "percentEncoded": false, "optional": false }

SESSION="yt2jelly"
SESSION_DIR="$HOME/synthetic/yt2jelly"

url="$1"

if [[ -z "$url" ]]; then
  echo "No URL provided" >&2
  exit 1
fi

mkdir -p "$SESSION_DIR"
tmux has-session -t "$SESSION" 2>/dev/null || tmux new-session -d -s "$SESSION" -c "$SESSION_DIR"

log_dir="$HOME/.local/log"
mkdir -p "$log_dir"
log_file="${log_dir}/yt2jelly-$(date +%Y%m%d-%H%M%S).log"

# workmux's tmux hooks compute their own "next free window index" for sidebar
# bookkeeping, which races with tmux's own auto-pick and makes plain
# `new-window` (no explicit index) intermittently fail with "index in use" --
# reliably reproducible, not just a one-off timing fluke. Picking the index
# ourselves (max existing + 1) sidesteps that shared computation entirely;
# explicit targets never collide the way auto-pick does.
next_index=$(($(tmux list-windows -t "$SESSION" -F '#{window_index}' | sort -n | tail -1) + 1))

jellyfin_icon="/Applications/Jellyfin Desktop.app/Contents/Resources/AppIcon.icns"

# Fire our own completion notification (with Jellyfin's icon) rather than
# relying on zsh-auto-notify's preexec/precmd hooks -- those only fire for
# commands that go through the shell's actual interactive prompt loop, which
# a plain `zsh -ic 'command'` never does, and riding them also means losing
# control over the notification's icon/content. Since we already know when
# the download starts and finishes (and what channel it's for), just call
# `alerter` directly with something more useful than a generic command line.
tmux new-window -t "${SESSION}:${next_index}" -c "$SESSION_DIR" -n yt2jelly \
  "zsh -ic '
    yt2jelly \"$url\" 2>&1 | tee -a \"$log_file\"
    dl_status=\$pipestatus[1]
    channel=\$(grep \"^Channel: \" \"$log_file\" | tail -1 | sed \"s/^Channel: //\")
    if [[ \$dl_status -eq 0 ]]; then
      title=\"\${channel:-yt2jelly} downloaded\"
      message=\"Sent to Jellyfin\"
    else
      title=\"\${channel:-yt2jelly} failed\"
      message=\"See $log_file\"
    fi
    alerter --title \"\$title\" --message \"\$message\" --app-icon \"$jellyfin_icon\" --timeout 30 >/dev/null 2>&1
  '"

# Keep the window open (as \"dead\") once the command exits instead of tmux
# auto-closing it, so there's time to read the final output; close it
# manually when done.
tmux set-window-option -t "${SESSION}:${next_index}" remain-on-exit on

# Reuse an already-open terminal's tmux client if one exists, by switching its
# session, instead of always spawning a brand new Ghostty window.
existing_client="$(tmux list-clients -F '#{client_tty}' 2>/dev/null | head -1)"
if [[ -n "$existing_client" ]]; then
  tmux switch-client -c "$existing_client" -t "$SESSION"
else
  open -na Ghostty --args -e tmux attach -t "$SESSION"
fi

open -a Ghostty

echo "Sent to yt2jelly: $url"
