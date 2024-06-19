export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

autoload -U compinit
compinit

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load ~/.zsh_plugins.txt

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
source ~/.iterm2_shell_integration.zsh
for file in ~/.{exports,aliases,functions,localrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# set the theme
autoload -Uz promptinit; promptinit
prompt pure

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey 'jk' vi-cmd-mode
bindkey '^F' fzf-cd-widget

# Make backspace behave normal in zsh's vi mode
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

# fzf-tab config
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# interactively navigate autocompletions
zstyle ':completion:*' menu yes select
# tmux popup integration
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Use C-<space> to trigger completion
zstyle ':fzf-tab:*' fzf-flags --bind "tab:ignore,btab:ignore,ctrl-space:toggle"


# Load 'fuck' alias
eval $(thefuck --alias) 

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
