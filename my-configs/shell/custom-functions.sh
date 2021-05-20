# Make directory then cd into it
newdir () 
{
  mkdir $1 && cd $1
}

# Transform the arguments into a valid url querystring
urlencode ()
{
  local args="$@"
  jq -nr --arg v "$args" '$v|@uri'; 
}

# Query duckduckgo
duckduckgo ()
{
  lynx "https://lite.duckduckgo.com/lite/?q=$(urlencode "$@")"
}

# Update dotfile repo or local config manually
dots ()
{
  local DOTS="$HOME/dotfiles"

  if [ "$1" = "-s" ]; then
    if [ "$PWD" != "$HOME" ]; then
      echo "you should be in your home directory"
      return 1
    fi
    local file="$2"
  else
    local file="$1"
  fi

  vi "$DOTS/$file" -c "vsplit $2" -c "cd $DOTS"
}

# Calculator utility
calc ()
{
  bc <<EOF
$@
EOF
}

# Extend the deno cli
deno()
{
  if [ -z "$1" ];then
    command deno
    return
  fi

  local cmd=$1; shift

  case "$cmd" in
    x)
      command deno run --allow-run ./Taskfile.js "$@"
      ;;
    start)
      command deno run --allow-run ./Taskfile.js start "$@"
      ;;
    init)
      cp ~/my-configs/deno/Taskfile.js ./
      echo "Taskfile.js created"
      ;;
    s|script)
      command deno run --import-map="$HOME/my-configs/deno/import-map.json" "$@"
      ;;
    *)
      command deno "$cmd" "$@"
      ;;
  esac
}

# Docker wrapper
doc()
{
  case "$1" in
    up)
      systemctl start docker
      ;;
    down)
      systemctl stop docker
      ;;
    start)
      shift;
      docker container start $@
      ;;
    stop)
      shift;
      docker container stop $@
      ;;
    ls)
      docker ps -a
      ;;
    li)
      docker images
      ;;
    x|exec)
      shift;
      docker exec $@
      ;;
    a|attach)
      docker container attach $2
      ;;
  esac
}

# mpv wrapper
play()
{
  local profile=''
  case $1 in
    l|low)
      shift;
      profile='--profile=low'
    ;;
    m|mid)
      shift;
      profile='--profile=mid'
    ;;
    a|audio)
      shift;
      profile='--vid=no'
    ;;
  esac

  local vid=''
  if [ -z "$1" ]; then
    vid="$(xsel -b --output)"
  else
    vid="$1"
  fi

  mpv $profile "$vid"
}

# Jump to frecuently visited directories
z () {
  if [ -z "$1" ]; then
    cd ~
    return
  fi

  local dest=$(jq -r ".[\"$1\"]" "$HOME/my-configs/dirs.json")

  if [ "$dest" = "null" ]; then
    echo "Can't find '$1'"
    return
  fi

  cd $dest
}

