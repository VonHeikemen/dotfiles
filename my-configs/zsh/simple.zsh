###
## Settings
###

# Turn off all beeps
unsetopt BEEP

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

setopt auto_cd
setopt multios
setopt prompt_subst

# Enable comments in interactive shell
setopt interactivecomments

autoload -U compaudit compinit
autoload -U colors

colors
compinit

zstyle ':completion:*' menu select

# Make sure the terminal is in application mode, which zle is active. Only then
# are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }

  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

###
## Keybindings
###

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

# [Ctrl+k] - delete line
bindkey '^K' kill-line

# [Ctrl+a] - Go to beginning of line
bindkey '^A' beginning-of-line

# [Ctrl+e] - Go to end of line
bindkey '^E'  end-of-line

###
## Prompt
###

autoload -Uz vcs_info

local _current_dir="%{$fg[blue]%}%3~%{$reset_color%}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*:*' formats "${_current_dir} %{$fg[green]%}%b"
zstyle ':vcs_info:*:*' nvcsformats "${_current_dir}" "" ""

# Display information about the current repository
repo_information() {
    echo "${vcs_info_msg_0_%%/.} $vcs_info_msg_1_"
}

# Output additional information about paths, repos and exec time
precmd() {
    vcs_info # Get version control info before we start outputting stuff
    print -P "\n$(repo_information)"
}

# Define prompts
PROMPT="%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure

###
## Aliases
###

alias -- -='cd -'
alias c1='cd ..'
alias c2='cd ../..'
alias c3='cd ../../..'
alias c4='cd ../../../..'

alias cl='clear'
alias cp='cp -i'
alias rmd='rm -r'
alias rmf='rm -rf'

# alias ls='exa'
# alias la='exa --git --header --long --all'

alias bb='echo -ne "\e[6 q"'

###
## Environment
###

export PATH=/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

