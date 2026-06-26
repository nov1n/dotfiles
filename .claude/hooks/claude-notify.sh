#!/bin/bash
# Notify on Claude Code Stop / Notification events, unless the originating
# tmux pane is already focused. Clicking the notification jumps back to it.
# The body is an AI summary of Claude's last message (Stop events).
#
# Requirements:
#   brew install vjeantet/tap/alerter
#   brew install --cask claude
#   $ANTHROPIC_API_KEY in the environment (used to summarize the last message)
#
# Wired from settings.json as async hooks (async:true is what lets this block on
# alerter without holding up Claude):
#   claude-notify.sh 'Finished'         (Stop)
#   claude-notify.sh 'Needs your input' (Notification)

LABEL="$1"
PAYLOAD=$(cat)
PANE="$TMUX_PANE"

# Decide between doing nothing, showing a banner, or an OS notification, based
# on whether you can actually see Claude's pane right now. The tmux on-screen
# reasoning only holds when Ghostty is the frontmost app; if you're in another
# app the pane isn't visible, so fall through to the OS notification.
#   - Ghostty frontmost, pane is focused        -> do nothing (you see it)
#   - Ghostty frontmost, pane visible not focused -> banner on the pane
#   - otherwise (other app / background window)  -> OS notification
if [ -n "$TMUX" ] && [ -n "$PANE" ]; then
  FRONT=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
  if [ "$FRONT" = "ghostty" ]; then
    read -r PANE_ACTIVE WINDOW_ACTIVE SESSION_ATTACHED \
      < <(tmux display-message -p -t "$PANE" '#{pane_active} #{window_active} #{session_attached}' 2>/dev/null)
    if [ "${SESSION_ATTACHED:-0}" != "0" ] && [ "$WINDOW_ACTIVE" = "1" ]; then
      [ "$PANE_ACTIVE" = "1" ] && exit 0
      # Visible but not focused: set this pane's border format to a yellow banner.
      # pane-border-status is kept always-on (blank) globally in .tmux.conf, so
      # changing only the per-pane format causes no resize/flicker. A pane-scoped
      # pane-focus-in hook reverts the format (back to the global blank) and
      # removes itself the moment you focus the pane. (Needs focus-events on,
      # which the tmux.conf already sets.)
      tmux set-option -p -t "$PANE" pane-border-format "#[align=centre,fg=black,bg=yellow,bold] ⬤  $LABEL  ⬤ "
      tmux set-hook -p -t "$PANE" pane-focus-in 'set-option -pu pane-border-format ; set-hook -pu pane-focus-in'
      exit 0
    fi
  fi
fi

LAST_MSG=$(jq -r '.last_assistant_message // ""' <<<"$PAYLOAD" 2>/dev/null)
CWD=$(jq -r '.cwd // ""' <<<"$PAYLOAD" 2>/dev/null)

# Body: AI summary of the last message (Stop), else the raw notification text
# (Notification, "Claude " stripped to avoid doubling the title), else the label.
SUMMARY=$(jq -r '.message // ""' <<<"$PAYLOAD" 2>/dev/null | sed 's/^Claude //')
if [ -n "$LAST_MSG" ] && [ -n "$ANTHROPIC_API_KEY" ]; then
  PROMPT="Summarize in 120 characters or less, output only the summary, no punctuation: $LAST_MSG"
  BODY=$(jq -n --arg p "$PROMPT" '{model:"claude-haiku-4-5-20251001", max_tokens:64, messages:[{role:"user", content:$p}]}')
  S=$(curl -s --max-time 10 https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "$BODY" | jq -r '.content[0].text // ""' 2>/dev/null)
  [ -n "$S" ] && SUMMARY="$S"
fi
[ -z "$SUMMARY" ] && SUMMARY="$LABEL"

RESULT=$(alerter \
  --message "$SUMMARY" \
  --title "Claude Code" \
  --subtitle "$LABEL · ${CWD/#$HOME/~}" \
  --sender "com.anthropic.claudefordesktop" \
  --actions "Show" \
  --timeout 10)

if [ -n "$RESULT" ] && [ "$RESULT" != "@TIMEOUT" ] && [ "$RESULT" != "@CLOSED" ]; then
  tmux switch-client -t "$PANE" 2>/dev/null
  osascript -e 'tell application "ghostty" to activate'
fi
