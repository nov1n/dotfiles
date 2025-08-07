# Install plugins
if [ ! -d "$HOME/.antidote" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
fi
source ~/.antidote/antidote.zsh
antidote load

# Load the shell dotfiles
for file in ~/.zsh_{aliases,functions,local,work}.sh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Configure shell history
HISTSIZE=500000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# The characters which ^<BS> should stop at
WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

# Configure autocomplete
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Custom keybindings
function zvm_after_init() {
  zvm_bindkey viins "^F" fzf-cd-widget
  zvm_bindkey viins "^T" fzf-file-widget
  zvm_bindkey viins "^Y" autosuggest-accept
  zvm_bindkey viins "^ " fzf-tab-complete # Tab key

  # Lazy load atuin, otherwise keybinds get overwritten, see https://github.com/jeffreytse/zsh-vi-mode/issues/12
  eval "$(atuin init zsh --disable-up-arrow)"
}

# Load tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Load autocmpletions
source <(docker completion zsh)
if command -v picnic >/dev/null 2>&1; then
  source <(picnic autocomplete script zsh)
fi

# SDKMAN!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Setup NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Cargo
. "$HOME/.cargo/env"

# Homebrew
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
