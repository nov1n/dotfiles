alias reload!='. ~/.zshrc'
alias evim='vim ~/.vimrc'
alias ezsh='vim ~/.zshrc'
alias ealias='vim ~/.dotfiles/zsh/aliases.zsh'
alias epath='vim ~/.dotfiles/custom/path.zsh'
alias etmux='vim ~/.tmux.conf'
alias ff='find . -name '
alias nov1n='cd /home/roberto/Code/go/src/github.com/nov1n'
alias exp='nautilus $(pwd)'
alias fh='history | grep '

# Kubernetes
alias kubeup='cd ~/Code/go/src/github.com/kubernetes/kubernetes; hack/local-up-cluster.sh'
alias etcdgui='sudo docker run --rm --name etcd-browser --net="host" -p 0.0.0.0:8000:8000 --env ETCD_HOST=127.0.0.1 --env -t -i etcd-browser'

# Fuck https://github.com/nvbn/thefuck
eval "$(thefuck --alias fuck)"
