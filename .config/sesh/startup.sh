#!/usr/bin/env bash
# sesh default_session startup: nvim (top-left) | claude (top-right) / terminal (20%, full-width bottom)

main_pane=$(tmux display-message -p '#{pane_id}')
tmux split-window -v -p 20 -t "$main_pane"
right_pane=$(tmux split-window -h -p 30 -P -F '#{pane_id}' -t "$main_pane")

tmux send-keys -t "$right_pane" 'claude' Enter

tmux select-pane -t "$main_pane"
exec nvim
