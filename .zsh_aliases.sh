alias v=nvim

alias ..="cd .."
alias c="clear"
alias g="git"
alias update="brew update && brew upgrade && brew cleanup && brew doctor && brew bundle dump -f --file=\$DOTFILES_HOME/script/Brewfile"
alias updot="git -C ~/dotfiles pull"
alias rel="exec zsh"
alias youtube-dl="yt-dlp"
alias play-yt='vlc --play-and-exit -f  "$(fd . ~/Documents/yt-dlp/ | fzf)" && habit move'
alias wakewin="wakeonlan 74:56:3C:45:75:87"
alias adot=dotfiles_adder.sh
alias resetusb="uhubctl -a cycle -p 2"
alias shfmt="shfmt -w -i 2 -ci -bn"
alias k=kubectl
alias d=docker

alias la="lsd -la --sort time"
alias ll="lsd -l --sort time"
alias tree="lsd -l --tree --depth=3"
#alias cat="bat"
alias lg="lazygit"
alias tw="taskwarrior-tui"

# Nudges
alias nslookup="doggo"
alias host="doggo"
alias htop="btm"

# Experimental
alias grep="rg"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Networking
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias flush="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Docker
alias dip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias dips="docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'"
alias dc='docker compose'

# Java
alias fast="mvnd -T1C -Dstyle.color=always clean install -DskipTests -Dverification.skip"
alias verify="mvnd -T 1.0C -Dstyle.color=always clean install -DskipTests"
alias slow="mvnd -T 1.0C clean install"
alias mvn="mvnd -Dstyle.color=always"
alias depgraph='mvn com.github.ferstl:depgraph-maven-plugin:aggregate -DcreateImage=true -Dincludes="tech.picnic.finance" && open target/dependency-graph.png'
alias sortpom='mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort -Dsort.sortDependencies=groupId,artifactId -Dsort.predefinedSortOrder="custom_1" -Dsort.keepBlankLines -Dsort.createBackupFile=false -Dsort.nrOfIndentSpace=4 -Dsort.expandEmptyElements=false'

# Others
alias lamy='ssh -t remarkable "cd ~/RemarkableLamyEraser && ./reinstall.sh"'
