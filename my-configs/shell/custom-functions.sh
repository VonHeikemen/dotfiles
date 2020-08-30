# Make directory then cd into it
newdir () 
{
  mkdir $1
  cd $1
}

# Give nnn the ability to cd into a directory
ll ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# Show how to burn an iso into a usb device
burnusb ()
{
  local device="99"
  local iso="99"

  for arg in "$@"
  do
    case "$arg" in
      -d=*|--device=*)
        device="${arg#*=}"
        shift;;
      -d|--device)
        device="$2"
        shift 2;;
      -i|--iso)
        iso="$2"
        shift 2;;
      -i=*|--iso=*)
        device="${arg#*=}"
        shift;;
      -h|--help)
        echo "\nUsage: $0 --device /device/path --iso /path/to/iso"
        echo "Might want to use \`fdisk -l\` or \`lsblk\` to check the available devices"
        return
    esac
  done

  if [ "$device" = "99" ];
  then
    echo "\nMust provide a --device/-d parameter"
    return
  fi

  if [ "$iso" = "99" ];
  then
    echo "\nMust provide a --iso/-i parameter"
    return
  fi

  local cmd="sudo dd bs=4M if=$iso of=$device status=progress oflag=sync"

  echo "\nUsing device $device"
  echo "Using image $iso\n"
  echo "This is the command you should use"
  echo "$cmd\n"
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
