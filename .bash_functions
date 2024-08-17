function command_exists() {
	command -v "$@" > /dev/null 2>&1
}

function activate-venv() {
  local selected_env
  selected_env=$(ls -a $VENV/ | fzf)

  if [ -n "$selected_env" ]; then
    source "$VENV/$selected_env/bin/activate"
  fi
}

function delete-branches() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs --no-run-if-empty git branch --delete --force
}

function git-switch(){
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0
  git branch | fzf | xargs git checkout;
}

# Function to list keys under a path
function list_vault_keys() {
  local path=$1
  vault kv list -format=json "$path" 2>/dev/null | /usr/bin/jq -r '.[]'
}

# Function to get secret value
function get_vault_secret() {
  local path=$1
  vault kv get -format=json "$path" 2>/dev/null | /usr/bin/jq -r '.data.data | to_entries | .[] | "\(.key): \(.value)"'
}

function check_vault_token(){
  vault token lookup &> /dev/null
  if [ "$?" -ne 0 ];then
    read -sp "Enter your vault password: " VAULT_PASSWORD
    echo ""
    vault login -method=userpass username=airflow password=${VAULT_PASSWORD} &> /dev/null

    if [ "$?" -eq 0 ];then
      log "Successfully logged into vault"
    else
      log "Failed to login to Vault. Check your credentials"
    fi
  fi
}

function vault-keys(){

  clear
  # Initial path
  current_path=${1:-airflow}
  [[ "$current_path" != */ ]] && current_path="$current_path/"

  : ${VAULT_ADDR?}
  check_vault_token

  while true; do
    # Get the list of keys and use fzf to select one
    selected_key=$(list_vault_keys "$current_path" | fzf --preview="vault kv get -format=json $current_path{} 2>/dev/null | jq -r '.data.data | to_entries | .[] | \"\(.key): \(.value)\"'" --preview-window=right:60%)

    # If no key is selected, exit
    [ -z "$selected_key" ] && break

    # If the selected key ends with a '/', it's a directory, so update the path
    if [[ "$selected_key" == */ ]]; then
      current_path="${current_path}${selected_key}"
    else
      # Otherwise, it's a secret, show the value and exit
      selected_value=$(get_vault_secret "$current_path$selected_key")
      log "Selected vault path: $current_path$selected_key"
      # echo "$selected_value"
      while IFS= read -r line; do
        info "$line"
      done <<< "$selected_value"
      break
    fi
  done
}

function log(){
  local green="\e[0;92m"
  local bold="\e[1m"
  local uline="\e[4m"
  local reset="\e[0m"
  local cur_date="$(date '+%d %B %Y %H:%M:%S')"
  local message="$1"
  printf "❯ [${cur_date}] ${green}%s${reset}\n" "${message}"
}

function info(){
  local green="\e[0;92m"
  local green="\e[0;93m"
  local bold="\e[1m"
  local uline="\e[4m"
  local reset="\e[0m"
  local message="$1"
  printf "❯ ${green}%s${reset}\n" "${message}"
}

function kexecs(){
  local container_name pod_name
  pod_name=$(kubectl get pod -o name| fzf +s -i)
  [[ -z "${pod_name}" ]] && return
  container_name=$(kubectl get "${pod_name}" -o jsonpath='{.spec.containers[*].name}'| tr -s " " "\n"| fzf +s -i)
  [[ -z "${container_name}" ]] && return
  kubectl exec --stdin --tty "${pod_name}" -c "${container_name}" -- sh
}

function kls(){
  args="${@:-}"
  local container_name pod_name
  pod_name=$(kubectl get pod -o name| fzf +s -i)
  [[ -z "${pod_name}" ]] && return
  container_name=$(kubectl get "${pod_name}" -o jsonpath='{.spec.containers[*].name}{" "}{.spec.initcontainers[*].name}'| tr -s " " "\n"| fzf +s -i)
  [[ -z "${container_name}" ]] && return
  kubectl logs "${pod_name}" -c "${container_name}" "$@"
}
