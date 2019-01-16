M2_HOME=/opt/maven
MAVEN_HOME=/opt/maven

PATH=$PATH:/home/robert/.local/bin
PATH=$PATH:/usr/local/lib/spark-2.2.0-bin-hadoop2.7/bin
PATH=$PATH:/usr/local/lib/istio-0.2.12/bin
PATH=$PATH:/usr/local/lib/scala-2.12.4/bin
PATH=$PATH:$M2_HOME/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/lib/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/lib/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/lib/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/lib/google-cloud-sdk/completion.zsh.inc'; fi
