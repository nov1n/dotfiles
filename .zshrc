# Install plugins
if [ ! -d "$HOME/.antidote" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
fi
source ~/.antidote/antidote.zsh
antidote load

# Load zprof if debugging flag is set
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zmodload zsh/zprof
fi

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

# Disable EOF (^-d) from quitting zsh, map to del
setopt IGNORE_EOF
bindkey '^D' delete-char

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
# custom fzf flags
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' prefix ''             # no dot before items

# Custom keybindings
function zvm_after_init() {
  zvm_bindkey viins "^F" fzf-cd-widget
  zvm_bindkey viins "^T" fzf-file-widget
  zvm_bindkey viins "^Y" autosuggest-accept
  zvm_bindkey viins "^ " fzf-tab-complete # Tab key
  zvm_bindkey viins "^I" undefined-key # Disable tab for autocompletion

  # Lazy load atuin, otherwise keybinds get overwritten, see https://github.com/jeffreytse/zsh-vi-mode/issues/12
  eval "$(atuin init zsh --disable-up-arrow)"
}

# Load tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Load autocmpletions
source <(docker completion zsh)
if command -v picnic >/dev/null 2>&1; then
  # `picnic autocomplete script zsh` also calls compinit, which reinitizliaes the completion system.
  # This is unnecessary and slows down zsh startup time, so we only add the completion function to the
  # fpath, and let the ez-compinit plugin take care of the rest.
  fpath=(/Users/carosi/Library/Caches/picnic-cli/autocomplete/functions/zsh $fpath)
fi

# SDKMAN!
[[ -s "/Users/carosi/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/carosi/.sdkman/bin/sdkman-init.sh"

# Cargo
. "$HOME/.cargo/env"

# Homebrew
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# fnm
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "`fnm env`"
fi

# Show profiling summary if debug flag is set
if [[ -n "$ZSH_DEBUGRC" ]]; then
  zprof
fi

