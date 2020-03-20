#! /bin/bash
function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

dte(){
  dte="$(date +"%A, %B %d | 🕒 %l:%M %p")"
  echo -e "$dte"
}

mem(){
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "🖪 $mem"
}


run xfce4-power-manager &
run clipit &
run volumeicon &
run nm-applet &
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run nitrogen --restore &
run xautolock -time 50 -locker blurlock &

while true; do
     xsetroot -name "$(mem) | $(dte)"
     sleep 10s    # Update time every ten seconds
done &
