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
