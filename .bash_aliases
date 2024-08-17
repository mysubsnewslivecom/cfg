# Setting aliases
alias mv='mv -v '
alias cp='cp -ipv '
alias rm='rm -vrf '
alias mkdir='mkdir -v '
alias c='clear'

alias ll='ls -lrat '
alias ld='ls -ld */'
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'

alias nc='nc -v -z -w 2 '
alias syncr='rsync -zarvh --progress --exclude=".git/"'
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

alias dusage='du -h . --max-depth=1|sort -h'
alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y'
alias egrep='grep -E --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

# Ansible
alias ap-apply='ansible-playbook main.yaml -K'

# fzf
if command_exists fzf; then
alias hx="eval \$(history | fzf -e +s | sed 's/ *[0-9]* *//')"
alias h="history | fzf -e +s"
alias get-secret=vault-keys
alias pyv=activate-venv
alias kns="kubectl get ns -o jsonpath='{.items[*].metadata.name}'| tr -s ' ' '\n'| fzf +s -i| xargs -I{} kubectl config set-context --current --namespace={}"
fi

# kubectl
if command_exists kubectl; then
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
alias kg='kubectl get '
alias get-ns='kubectl config view --minify -o jsonpath="{..namespace}"; echo'
alias curns='kubectl config view --minify --output "jsonpath={..namespace}"; echo'

alias kname="kubectl get deployment -o=jsonpath='{.items[*].metadata.name}'"
alias kdver="kubectl get deployments.apps -o=custom-columns='DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[*].image,READY_REPLICAS:.status.readyReplicas,NAMESPACE:.metadata.namespace,LABEL:.spec.template.metadata.labels.*'"

alias kgp='kubectl get pods'
alias kwatch='kubectl get pods --watch'
alias kpsort='kubectl get pods --sort-by="{.status.containerStatuses[:1].restartCount}"'
alias 'kgp!'='kubectl get pods --field-selector=status.phase!=Running'
alias kdp='kubectl describe pods'
alias kd='kubectl describe'

alias krpod='kubectl rollout restart $(kubectl get deploy -o name)'

alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klf1h='kubectl logs --since 1h -f'
alias klf1m='kubectl logs --since 1m -f'
alias klf1s='kubectl logs --since 1s -f'
fi

if command_exists docker; then
alias d=docker
alias dexec="docker run -it --rm --network alpine-net"
alias dockerlogin='docker login --username mysubsnews --password $(echo $DOCKER_HUB_B64_TOKEN|base64 -d)'
fi


if command_exists terraform; then
alias tf='terraform'
alias tfa='terraform apply'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfiu='terraform init -upgrade'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfv='terraform validate'
alias tfs='terraform state'
alias tfsh='terraform show'
fi
