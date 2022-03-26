#!/bin/bash

if [[ ! -z $1 && ! -z $2 ]]; then
  modeline=$(cvt $1 $2 | grep Modeline | cut -f 2- -d ' ')
  res=$(cvt $1 $2 | grep Modeline | awk '{print$2}')
  display=$(xrandr --listmonitors | grep 0: | awk '{print$4}')
  xrandr --newmode ${modeline}
  xrandr --addmode ${display} ${res}
  xrandr --output ${display} --mode ${res}
else
  echo "Enter desired resolution separated by a space. Example: 1920 1080"
  read input
  modeline=$(cvt ${input} | grep Modeline | cut -f 2- -d ' ')
  res=$(cvt ${input} | grep Modeline | awk '{print$2}')
  display=$(xrandr --listmonitors | grep 0: | awk '{print$4}')
  xrandr --newmode ${modeline}
  xrandr --addmode ${display} ${res}
  xrandr --output ${display} --mode ${res}
fi