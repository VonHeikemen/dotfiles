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
    if [ -f "./.git/session-nvim" ] || [ -f "./.session-nvim" ]; then
      vi -c "SessionRestore!"
      return
    fi
  fi

  local file="$HOME/.local/share/nvim/sessions/$1.vim"

  if [ -f "$file" ]; then
    vi -c "SessionLoad $1"
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
    echo "Provide an argument"
    return
  fi

  case "$1" in
    it|italy)
      TZ_LIST="Etc/GMT-2,Italy" command tz
    ;;
    cal|california)
      TZ_LIST="Etc/GMT+7,USA California" command tz
    ;;
    uk|london)
      TZ_LIST="Etc/GMT-1,UK" command tz
    ;;
    *)
      echo "Wrong argument"
    ;;
  esac
}

