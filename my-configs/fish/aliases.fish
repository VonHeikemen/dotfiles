set -Ux EDITOR 'nvim'
set -Ux PYTHONUSERBASE $HOME/.local
set -Ux TERMINAL 'kitty'
set -Ux FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*" --glob "!cache/*" --glob "!node_modules/*"'
set -Ux FZF_DEFAULT_OPTS '--layout=reverse --border' 
set -Ux BAT_THEME 'base16'
set -Ux NNN_FCOLORS 'c1e20402000506f7c6d6ab09'

alias -s duh 'du -d 1 -h'

alias -s c1 'cd ..'
alias -s c2 'cd ../..'
alias -s c3 'cd ../../..'
alias -s c4 'cd ../../../..'

alias -s cl 'clear'
alias -s cp 'cp -i'

alias -s np 'pnpm'
alias -s npr 'pnpm run'

alias -s lzg 'lazygit'

alias -s ta 'tmux attach -t'
alias -s tl 'tmux list-sessions'
alias -s ts 'tmux new-session -A -D -s'
alias -s tmus 'ts music (which cmus)'

alias -s pmd-start 'ts pomodoro gone -e "notify-send -u critical Pomodoro Timeout"'
alias -s pomd 'gone -e "notify-send -u critical Pomodoro Timeout"'

alias -s tvi 'ts vi'

alias -s dcc 'docker-compose'

alias -s doc-start 'systemctl start docker'
alias -s doc-ls 'docker ps -a'

alias -s ls 'exa'
alias -s la 'exa --git --header --long --all'

alias -s yt "youtube-dl -f 'bestvideo[height<=720]+bestaudio/best[height<=720]'"

