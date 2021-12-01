#!/bin/bash
package="autorandr"

sudo apt install -y autorandr
echo "xrandr $(autorandr --config | sed "s/^/--/g" | sed 's/$/ \\/g' | sed '/crtc/d')" > new-xrandr.sh