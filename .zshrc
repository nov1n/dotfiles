# Install plugins
if [ ! -d "$HOME/.antidote" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
fi
source ~/.antidote/antidote.zsh
antidote load

# Load autosuggestions
autoload -U compinit
compinit

# Set the theme
autoload -Uz promptinit; promptinit

# Load the shell dotfiles
for file in ~/.{path,exports,aliases,functions,localrc}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Configure autocomplete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Set keybindings
bindkey '-M' viins '^W' backward-kill-word
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^ ' fzf-cd-widget
bindkey '^Y' autosuggest-accept
# Make vi-mode's backspace behave as expected
bindkey "^?" backward-delete-char
bindkey "^H" backward-delete-char

# Load tools
eval $(thefuck --alias) 
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Set zellij tab name to pwd
zellij_tab_name_update
chpwd_functions+=(zellij_tab_name_update)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
