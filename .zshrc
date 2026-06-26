# In Ghostty (and not already inside tmux), hand off to tmux before any other
# shell setup: the quick terminal gets the "quick" session, regular windows get
# the most recently used session other than "quick" (so the quick terminal can't
# hijack which session normal windows reopen into). Done here rather than via
# Ghostty's `command` so GHOSTTY_QUICK_TERMINAL is set.
if [[ "$TERM_PROGRAM" == "ghostty" && -z "$TMUX" ]]; then
  if [[ "$GHOSTTY_QUICK_TERMINAL" == "1" ]]; then
    exec tmux new-session -A -s quick
  fi
  target=$(tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null \
    | grep -vw quick | sort -rn | head -n1 | cut -d' ' -f2-)
  if [[ -n "$target" ]]; then
    exec tmux attach -t "$target"
  else
    exec tmux attach
  fi
fi

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

# Load the shell dotfiles (.zsh_local.sh is sourced from .zshenv instead, so
# it's also available to non-interactive shells).
for file in ~/.zsh_{aliases,functions,work}.sh; do
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

# fzf project selector widget
fzf-project-widget() {
  local selected_dir
  selected_dir=$(find ~/Projects/picnic ~/Projects/personal -type d -maxdepth 1 -mindepth 1 2>/dev/null | \
    awk -F/ '{OFS="\t"; print $(NF-1)"/"$NF "\t" $0}' | \
    fzf --with-nth=1 | \
    cut -f2)

  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir"
    zle reset-prompt
  fi
}
zle -N fzf-project-widget

# Custom keybindings
function zvm_after_init() {
  zvm_bindkey viins "^F" fzf-cd-widget
  zvm_bindkey viins "^T" fzf-file-widget
  zvm_bindkey viins "^Y" autosuggest-accept
  zvm_bindkey viins "^I" fzf-tab-complete # Tab key
  zvm_bindkey viins "^O" fzf-project-widget

  # Lazy load atuin, otherwise keybinds get overwritten, see https://github.com/jeffreytse/zsh-vi-mode/issues/12
  eval "$(atuin init zsh --disable-up-arrow)"
}

# Load tools
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

# Bob (Neovim version manager)
export PATH="/Users/carosi/.local/share/bob/nvim-bin:$PATH"

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

[ -x "$(command -v ai_cmd)" ] && eval "$(ai_cmd --init zsh)"

# Required for Picnic's Python setup
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"

# zoxide must init last so its precmd/chpwd hooks aren't clobbered by other tools.
export _ZO_DOCTOR=0
eval "$(zoxide init zsh)"
