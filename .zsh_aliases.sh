alias v=nvim
alias vim='echo Use \"v\" instead!'

alias c="clear"
alias g="git"
alias update="brew update && brew upgrade && brew cleanup && brew doctor && brew bundle dump -f --file=\$DOTFILES_HOME/script/Brewfile"
alias updot="git -C ~/dotfiles pull"
alias rel="exec zsh"
alias edot="cd dotfiles; nvim"
alias notes="cd ~/Notes; vim"
alias youtube-dl="yt-dlp"
alias wakewin="wakeonlan 74:56:3C:45:75:87"
alias adot=dotfiles_adder.sh

alias ll="lsd -l"
alias tree="lsd -l --tree --depth=3"
alias cat="bat"
alias grep="rg"
alias cd="z"
alias lg="lazygit"

# Nudges
alias nslookup="echo Use doggo!"
alias host="echo Use doggo!"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

alias stretch="vlc --play-and-exit -f ~/Documents/yt-dlp/15-min-standing-yoga.mkv"

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
