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

# Add timestamp to prompt
RPROMPT='%*' # hh:mm:ss
TRAPALRM() {
    zle reset-prompt
}

bindkey '^[[Z' reverse-menu-complete
bindkey '^y' autosuggest-accept
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey jk vi-cmd-mode
bindkey '^G' fzf-cd-widget


# fzf-tab config
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# interactively navigate autocompletions
zstyle ':completion:*' menu yes select

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
