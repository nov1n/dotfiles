alias ll="ls -l"
alias reload!='. ~/.zshrc'
alias evim='e ~/.vimrc'
alias ezsh='e ~/.zshrc'
alias ealias='e ~/.dotfiles/zsh/aliases.zsh'
alias epath='e ~/.dotfiles/custom/path.zsh'
alias etmux='e ~/.tmux.conf'
alias ff='find . -name '
alias nov1n='cd /home/roberto/Code/go/src/github.com/nov1n'
alias exp='nautilus $(pwd)'
alias fh='history | grep '
alias pubip='wget -qO- http://ipecho.net/plain ; echo'
alias vim='vi'
alias dopen='xdg-open'
alias work='cd ~/Code/go/src/github.com/nerdalize/terraform-etcd'
alias stack='sudo mount ~/stack'

# Kubernetes
alias kubeup='cd ~/Code/go/src/github.com/kubernetes; sudo hack/local-up-cluster.sh'
alias kubecfg='cd ~/Code/go/src/github.com/kubernetes; hack/local-up-config.sh'
alias etcdgui='sudo docker run --rm --name etcd-browser --net="host" -p 0.0.0.0:8000:8000 --env ETCD_HOST=127.0.0.1 --env -t -i etcd-browser'
alias terracfg='export TF_LOG_PATH=./crash.log && export TF_LOG=TRACE'

# Fuck https://github.com/nvbn/thefuck
eval "$(thefuck --alias fuck)"

# Training disabled commands
alias rm='printf "This is not the command you are looking for.\n
trash-put           trash files and directories.\n
trash-empty         empty the trashcan(s).\n
trash-list          list trashed files.\n
trash-restore       restore a trashed file.\n
trash-rm            remove individual files from the trashcan.\n
"; false'
alias vim='echo "Use atom instead!"'
