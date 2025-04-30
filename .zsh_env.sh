export ZSH_COMPDUMP=$HOME/.zsh/cache/.zcompdump-$HOST
# See https://www.johnhawthorn.com/2012/09/vi-escape-delays/
export KEYTIMEOUT=1

export DOCKER_HOST=""

export PROJECTS=$HOME/Projects
export DOTFILES_HOME=$HOME/dotfiles
export NOTES_HOME=$HOME/Notes

# Make nvim the default editor.
export EDITOR="nvim";

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

# The characters which ^-W should stop at
WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Adapted from https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_moon.sh
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#2d3f76 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:-1 \
  --color=header:#2d3f76 \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"

# nvm
export NVM_DIR="$HOME/.nvm"
