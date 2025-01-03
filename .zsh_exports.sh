export ZSH_COMPDUMP=$HOME/.zsh/cache/.zcompdump-$HOST
# See https://www.johnhawthorn.com/2012/09/vi-escape-delays/
export KEYTIMEOUT=1

export PROJECTS=$HOME/Projects
export DOTFILES_HOME=$HOME/dotfiles
export NOTES_HOME=$HOME/Documents/notes

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
export FZF_DEFAULT_OPTS="\
--ansi \
--color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic' \
--bind 'ctrl-y:accept' \
--prompt '  ' \
--no-info \
--no-separator \
--reverse"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"

# nvm
export NVM_DIR="$HOME/.nvm"
