#! /bin/bash
# baraction.sh for spectrwm status bar

dte(){
  dte="$(date +"%A, %B %d | %l:%M %p")"
  echo -e "$dte"
}

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
while :; do

	echo -e "$(dte)"

	sleep $SLEEP_SEC
done
