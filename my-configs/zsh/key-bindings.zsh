autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U edit-command-line

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

# start typing + [Up-Arrow] - fuzzy find history forward
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search

# start typing + [Down-Arrow] - fuzzy find history backward
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# [Space] - do history expansion
bindkey ' ' magic-space

# [Home] - Go to beginning of line
bindkey "${terminfo[khome]}" beginning-of-line

# [End] - Go to end of line
bindkey "${terminfo[kend]}"  end-of-line

# [PageUp] - Up a line of history
bindkey "${terminfo[kpp]}" up-line-or-history

# [PageDown] - Down a line of history
bindkey "${terminfo[knp]}" down-line-or-history

# [Shift-tab] - move to the previous completion rather than the next
bindkey "${terminfo[kcbt]}" reverse-menu-complete

# [Ctrl+RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word

# [Ctrl+LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word

# [Ctrl+x-Ctrl+e] - use $EDITOR to write a command
bindkey '^x^e' edit-command-line

# [Backspace] - delete backward
bindkey '^?' backward-delete-char

# [Ctrl+l] - enter vi-mode
# bindkey '^l' vi-cmd-mode

# [Ctrl+w] - delete word
bindkey -M viins '^W' backward-kill-word

# [Ctrl+h] - delete backward 
bindkey -M viins '^H' backward-delete-char

# [Ctrl+u] - delete line
bindkey -M viins '^U' backward-kill-line

# [Slash] - search history with fzf
bindkey -M vicmd '/' fzf-history-widget

# Disable delay when changing modes
export KEYTIMEOUT=1

# Change cursor shape
zle-keymap-select () {
  if [ $KEYMAP = vicmd ]; then
    # the command mode for vi
    echo -ne "\e[2 q"
  else
    # the insert mode for vi
    echo -ne "\e[6 q"
  fi
}
zle -N zle-keymap-select

echo -ne "\e[6 q"

source "/usr/share/fzf/key-bindings.zsh"
