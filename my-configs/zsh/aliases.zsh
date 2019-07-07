export PATH=$HOME/.npm-packages/bin:$PATH
export EDITOR="nvim"
export PYTHONUSERBASE=~/.local
export TERMINAL='kitty'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!cache/*" --glob "!node_modules/*"'

alias -- -='cd -'

alias cp="cp -i"
alias df='df -h'
alias free='free -m'

alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias npr="pnpm run"
alias npi='pnpm install'
alias npi-flat='pnpm install --shamefully-flatten'

alias lzg="lazygit"

alias ta="tmux attach -t"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"
alias tmus='tmux new-session -A -D -s music "$(which cmus)"'

alias pomd='tmux new-session -A -D -s pomodoro'
alias pmd-start='pomd gone -e "notify-send -u critical Pomodoro Timeout"'

alias vi-s="nvim -S Session.vim"

alias dcc="docker-compose"

alias doc-start="systemctl start docker"
alias doc-ls="docker ps -a"

alias la='exa --git --header --long --all'
alias ic='node ~/code-stuff/check-internet/index.js "$(which chromium)" --stdout'

alias qtr='qtile-cmd -o cmd -f restart'
alias qtl='less +F ~/.local/share/qtile/qtile.log'

