# SSH identities (Ex. 'id_rsa')
local identities=()

# Get the filename to store/lookup the environment from
local _ssh_env_cache="$HOME/.ssh/environment-${HOST/.*/}"

_add_identities() {
  ssh-add -l > /dev/null

  if [ $? -eq 1 ]; then
    for id in $identities; do
      ssh-add "$HOME/.ssh/$id"
    done
  fi
}

_start_agent() {
  local lifetime='4h'

  # start ssh-agent and setup environment
  echo "\nStarting ssh-agent..."
  ssh-agent -s ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! $_ssh_env_cache
  chmod 600 $_ssh_env_cache
  . $_ssh_env_cache > /dev/null
}

_launch_agent() {
  # check identites array
  [[ -z $identities ]] && return

  if [[ -f "$_ssh_env_cache" ]]; then
    # Source SSH settings, if applicable
    . $_ssh_env_cache > /dev/null
    
    if [[ $USER == "root" ]]; then
      FILTER="ax"
    else
      FILTER="x"
    fi

    # check if ssh-agent is already running
    ps $FILTER | grep ssh-agent | grep -q $SSH_AGENT_PID || {
      _start_agent
    }
  else
    _start_agent
  fi

  _add_identities
}

_launch_agent
unfunction _start_agent _add_identities _launch_agent

