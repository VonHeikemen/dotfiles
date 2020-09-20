function newdir --description 'Make directory then cd into it'
  mkdir $argv[1]
  cd $argv[1]
end

funcsave newdir

function n --wraps nnn --description 'support nnn quit and change directory'
    # Block nesting of nnn in subshells
    if test -n "$NNNLVL"
        if [ (expr $NNNLVL + 0) -ge 1 ]
            echo "nnn is already running"
            return
        end
    end

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "-x" as in:
    #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    if test -n "$XDG_CONFIG_HOME"
        set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    else
        set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
    end

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn $argv

    if test -e $NNN_TMPFILE
        source $NNN_TMPFILE
        rm $NNN_TMPFILE
    end
end

funcsave n

function urlencode --description 'Transform the arguments into a valid url querystring'
  jq -nr --arg v "$argv" '$v|@uri' 
end

funcsave urlencode

function duckduckgo --description 'Query duckduckgo'
  set -l query (urlencode $argv)
  lynx "https://lite.duckduckgo.com/lite/?q=$query"
end

funcsave duckduckgo

function dots --description 'Update dotfile repo or local config manually'
  set -l DOTS "$HOME/code-stuff/dotfiles"

  if test "$argv[1]" = "-s"
    if test "$PWD" != "$HOME"
      echo 'You should in your home directory'
      return 1
    end
    set file "$argv[2]"
  else
    set file "$argv[1]"
  end

  vi "$DOTS/$file" -c "vsplit $argv[2]" -c "cd $DOTS"
end

funcsave dots

