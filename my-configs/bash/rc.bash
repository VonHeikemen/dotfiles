#!/usr/bin/env bash

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# use readline on history
shopt -s histreedit

# load history line onto readline buffer for editing
shopt -s histverify

# save history with newlines instead of ; where possible
shopt -s lithist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null


