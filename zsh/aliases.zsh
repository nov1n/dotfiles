alias ll="ls -hltr"
alias debugger="r2 -c=H /bin/ls"
alias reload!='. ~/.zshrc'
alias evim='e ~/.vimrc'
alias ezsh='e ~/.zshrc'
alias ealias='e ~/.dotfiles/zsh/aliases.zsh'
alias epath='e ~/.dotfiles/custom/path.zsh'
alias etmux='e ~/.tmux.conf'
alias ff='find . -name '
alias exp='nautilus $(pwd)'
alias pubip='wget -qO- http://ipecho.net/plain ; echo'
alias dopen='xdg-open'
alias stack='sudo mount ~/stack'
alias fixdep='sudo apt-get -f install'
alias scratch='cd $(mktemp -d)'
alias nettop='nethogs'
alias grepmail='grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b"'
alias reprep='!!:gs/'
alias screenrec='peek'
alias defgw='ip route | grep default | awk '"'"'{print $3}'"'"' | cb'
alias etouchgestures='vim ~/.config/fusuma/config.yml'
alias installed='sudo apt list --installed'
alias winestaging='/opt/wine-staging/bin/wine'
alias winestagingcfg='/opt/wine-staging/bin/winecfg'
alias applications='/usr/share/applications'

# Kubernetes
alias kubeup='cd ~/Code/go/src/github.com/kubernetes; sudo hack/local-up-cluster.sh'
alias kubecfg='cd ~/Code/go/src/github.com/kubernetes; hack/local-up-config.sh'
alias etcdgui='sudo docker run --rm --name etcd-browser --net="host" -p 0.0.0.0:8000:8000 --env ETCD_HOST=127.0.0.1 --env -t -i etcd-browser'
alias terracfg='export TF_LOG_PATH=./crash.log && export TF_LOG=TRACE'

# Fuck https://github.com/nvbn/thefuck
eval "$(thefuck --alias fuck)"
