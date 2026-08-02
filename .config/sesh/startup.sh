#!/usr/bin/env bash
# sesh default_session startup: nvim (main, top-left) / terminal (20%, bottom-left) | claude (40% right)

main_pane=$(tmux display-message -p '#{pane_id}')
right_pane=$(tmux split-window -h -p 40 -P -F '#{pane_id}')
tmux split-window -v -p 20 -t "$main_pane"

tmux send-keys -t "$right_pane" 'claude' Enter

tmux select-pane -t "$main_pane"
exec nvim
