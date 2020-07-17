#!/usr/bin/env bash

export PATH="$HOME/bin:$HOME/.npm-packages/bin:$PATH"
export EDITOR='nvim'
export PYTHONUSERBASE=~/.local
export TERMINAL='kitty'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!cache/*" --glob "!node_modules/*"'
export FZF_DEFAULT_OPTS='--layout=reverse --border' 

alias duh='du -d 1 -h'

alias -- -='cd -'
alias c1='cd ..'
alias c2='cd ../..'
alias c3='cd ../../..'
alias c4='cd ../../../..'

alias cl='clear'
alias cp='cp -i'

alias np='pnpm'
alias npr='pnpm run'

alias lzg='lazygit'

alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias ts='tmux new-session -A -D -s'
alias tmus='ts music "$(which cmus)"'

alias pmd-start='ts pomodoro gone -e "notify-send -u critical Pomodoro Timeout"'
alias pomd='gone -e "notify-send -u critical Pomodoro Timeout"'

alias tvi='ts vi'
alias vi-s='nvim -S Session.vim'

alias dcc='docker-compose'

alias doc-start='systemctl start docker'
alias doc-ls='docker ps -a'

# alias ls='ls --color=auto'
# alias la='ls -lAh'
alias ls='exa'
alias la='exa --git --header --long --all'

alias yt="youtube-dl -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"

