export EDITOR='nvim'
export PYTHONUSERBASE=~/.local
export TERMINAL='kitty'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!cache/*" --glob "!node_modules/*" --glob "!vendor/*"'
export FZF_DEFAULT_OPTS='--layout=reverse --border' 
export BAT_THEME='base16'
export NNN_FCOLORS='c1e20402000506f7c6d6ab09'
export DENO_INSTALL="$HOME/.deno"

export PATH=$PATH:$HOME/bin:$HOME/.config/npm/packages/bin:$DENO_INSTALL/bin

alias duh='du -d 1 -h'

alias -- -='cd -'
alias c1='cd ..'
alias c2='cd ../..'
alias c3='cd ../../..'
alias c4='cd ../../../..'

alias cl='clear'
alias cp='cp -i'
alias rmd='rm -r'
alias rmf='rm -rf'

alias lzg='lazygit'

alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias ts='tmux new-session -A -D -s'
alias tmus='ts music "$(which cmus)"'

alias p='play'
alias w='play low'
alias ww='play mid'
alias listen='play audio'

alias pmd-start='ts pomodoro gone -e "notify-send -u critical Pomodoro Timeout"'
alias pomd='gone -e "notify-send -u critical Pomodoro Timeout"'

alias tvi='ts vi'

alias dcc='docker-compose'

# alias ls='ls --color=auto'
# alias la='ls -lAh'
alias ls='exa'
alias la='exa --git --header --long --all'

alias see='bat'

alias yt="youtube-dl -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"

alias psl='ps ax --format pid,user,args'
alias psg='psl | rg'

alias localip="ip route | awk '/^192.168.*/ { print \$9 }'"

