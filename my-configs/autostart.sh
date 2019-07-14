#! /bin/bash
function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run xfce4-power-manager &
run clipit &
run volumeicon &
run nm-applet &
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
run nitrogen --restore &
run xautolock -time 50 -locker blurlock &

