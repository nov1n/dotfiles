export ZSH_COMPDUMP=$HOME/.zsh/cache/.zcompdump-$HOST
# See https://www.johnhawthorn.com/2012/09/vi-escape-delays/
export KEYTIMEOUT=1

export PROJECTS=$HOME/Projects
export DOTFILES_HOME=$HOME/dotfiles
export NOTES_HOME=$HOME/Notes

# Make nvim the default editor.
export EDITOR="nvim";

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Use nvim as manpager.
export MANPAGER="nvim -c 'Man!'";

# Fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Adapted from https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_moon.sh
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --no-scrollbar \
  --layout=reverse \
  --border=none \
  --scroll-off=3 \
  --no-cycle \
  --marker='·' \
  --pointer='' \
  --prompt='❯ ' \
  \
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

# Configure path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.rd/bin:$PATH"

# From https://picnic.atlassian.net/wiki/spaces/DEVPLA/pages/4395466765/Poetry+Getting+started+with+Python+at+Picnic#6.-Install-picnic-poetry-plugin
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"

# Default aws profile
export AWS_PROFILE="picnic-artifacts"
. "/Users/carosi/.local/share/bob/env/env.sh"
