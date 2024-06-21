export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

autoload -U compinit
compinit

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load

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

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^ ' fzf-cd-widget

# zsh-autosuggestions
bindkey '^Y' autosuggest-accept
bindkey 'jk' vi-cmd-mode
bindkey -s ^f "tmux-sessionizer\n"

# Make backspace behave normal in zsh's vi mode
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

# Load 'fuck' alias
eval $(thefuck --alias) 

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
