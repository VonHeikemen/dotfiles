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
  w3m "https://lite.duckduckgo.com/lite/?q=$(urlencode "$@")"
}

# Read song lyrics from azlyrics.com
lyrics ()
{
  local artist=$(echo $1 | sed -e "s/\s//g" | tr '[:upper:]' '[:lower:]')
  local song=$(echo $2 | sed -e "s/\s//g" | tr '[:upper:]' '[:lower:]')
  local site='https://www.azlyrics.com/lyrics'
  w3m "$site/$artist/$song.html"
}

# Calculator utility
calc ()
{
  bc <<EOF
$@
EOF
}

# mpv wrapper
play ()
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

# Jump to frequently visited directories
z () 
{
  if [ -z "$1" ]; then
    cd ~
    return
  fi

  local dirs="$HOME/my-configs/dirs.json"
  local dest=$(awk -F'"' "/^  \"$1\":/ { print \$4 }" "$dirs")

  if [ -z "$dest" ]; then
    echo "Can't find '$1'"
    return
  fi

  cd $dest
}

# use file explorer (vifm) to change current working directory
j ()
{
  local dest=$(vifm --choose-dir - "$@")

  if [ $? -eq 0 ]; then
    cd "$dest"
  fi
}

# open neovim session for current directory
code ()
{
  if [ -z "$1" ]; then
    vi -c "ResumeWork!"
    if [ $? -eq 2 ]; then
      echo "\nThere is no project or session available"
    fi
    return
  fi

  local dir="$HOME/.local/share/nvim/project-store/$1/"

  if [ -d "$dir" ]; then
    vi -c "ProjectLoad $1"
    return
  fi

  echo "There is no session available"
}

# start timer
tme ()
{
  if [ -z "$1" ]; then
    return
  fi

  if [ -z "$2" ]; then
    timer "$1" && \
      notify-send -t 5000 'Timer finished!'
    return
  fi

  timer -n "$1" "$2" && \
    notify-send -t 10000 "$1" "finished!"
}

# displays time across the time zones of your choosing
tz ()
{
  if [ -z "$1" ]; then
    command tz
    return
  fi

  case "$1" in
    -l|-list)
      command tz -list
    ;;
    -n)
      TZ_LIST="$2" command tz
    ;;
    cet|cest)
      TZ_LIST="CET,Central European Time" command tz
    ;;
    pt|pdt|pst)
      TZ_LIST="US/Pacific,US Pacific Time" command tz
    ;;
    uk|bst)
      TZ_LIST="Europe/London,UK" command tz
    ;;
    ch|chile)
      TZ_LIST="America/Santiago,Chile" command tz
    ;;
    mt|mst|mdt)
      TZ_LIST="MST7MDT,Mountain Time" command tz
    ;;
    et|est)
      TZ_LIST="EST,US Eastern Time" command tz
    ;;
    ct|cdt)
      TZ_LIST="US/Central,US Central" command tz
    ;;
    *)
      echo "$1 was not found"
    ;;
  esac
}

