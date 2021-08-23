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


# OLD
#echo "Virtual screen detected, enter the number corresponding to your desired reolution below:"
#menu1="1: 1920x1080 (1080p)
#2: 1600x900
#3: 1280x720 (720p)
#4: 3840x2160 (4K)"
#while x=1;echo "$menu1"; do
#read res
#if [ $res -eq 1 ]; then
  #cvt 1920 1080
  #xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
  #xrandr --addmode Virtual1 "1920x1080_60.00"
  #xrandr --output Virtual1 --mode "1920x1080_60.00"
  #break
  #elif [ $res -eq 2 ]; then
    #cvt 1600 900
    #xrandr --newmode "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
    #xrandr --addmode Virtual1 "1600x900_60.00"
    #xrandr --output Virtual1 --mode "1600x900_60.00"
    #break
  #elif [ $res -eq 3 ]; then
    #cvt 1280 720
    #xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
    #xrandr --addmode Virtual1 "1280x720_60.00"
    #xrandr --output Virtual1 --mode "1280x720_60.00"
    #break
  #elif [ $res -eq 4 ]; then
    #cvt 1280 720
    #xrandr --newmode "3840x2160_60.00"  712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
    #xrandr --addmode Virtual1 "3840x2160_60.00"
    #xrandr --output Virtual1 --mode "3840x2160_60.00"
    #break
#else
#echo "Invalid Selection, please try again."
#fi
#done
