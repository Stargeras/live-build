#!/bin/bash
gsettings set org.gnome.desktop.interface gtk-theme  'io.elementary.stylesheet.blueberry'
gsettings set org.gnome.desktop.interface icon-theme 'elementary'
gsettings set org.gnome.desktop.interface cursor-theme 'elementary'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close:maximize'
gsettings set org.pantheon.desktop.gala.animations enable-animations 'true'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/elementaryos-default'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set io.elementary.desktop.wingpanel.datetime clock-format '12h'
gsettings set io.elementary.code.saved-state window-size '(1280, 810)'
#gsettings set io.elementary.files.preferences window-size '(1280, 810)'
#dconf write /net/launchpad/plank/docks/dock1/hide-mode "'none'"
dconf write /net/launchpad/plank/docks/dock1/theme "'Gtk+'"
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
# Terminal font
dconf write /org/gnome/desktop/interface/monospace-font-name "'Liberation Mono 11'"
# Epiphany browser
gsettings set org.gnome.Epiphany homepage-url 'https://archlinux.org'
dconf write /org/gnome/epiphany/state/window-size '(1620, 952)'
gsettings set org.gnome.Epiphany default-search-engine 'Google'
gsettings set org.gnome.Epiphany restore-session-policy 'crashed'

# Desktop zoom
# gsettings set org.gnome.desktop.interface text-scaling-factor '1.25'
# gsettings set org.gnome.desktop.interface text-scaling-factor '1.50'

# imwheel config
cat > ${HOME}/.imwheelrc << EOF
".*"
None,      Up,   Button4, 3
None,      Down, Button5, 3
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
EOF
imwheel -kill

### PLANK DOCK
# App names are in /usr/share/applications without .desktop extension
dockitems="chromium io.elementary.files io.elementary.terminal io.elementary.code io.elementary.switchboard"
dockpath="${HOME}/.config/plank/dock1/launchers"
dconfstring=""
# INITIALIZE PLANK. IF THIS IS NOT DONE FIRST, DOCK ITEMS GET RESET
nohup plank > /dev/null 2>&1 &
sleep 1
sudo pkill -9 plank
# EXECUTE MODIFICATIONS
rm -f ${dockpath}/*
for item in ${dockitems}; do
  cat > ${dockpath}/${item}.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/${item}.desktop
FOE
  dconfstring+="'${item}.dockitem', "
done 
# NEEDED FOR CORRECT ORDERING
dconf write /net/launchpad/plank/docks/dock1/dock-items "[${dconfstring::-2}]"
# START PLANK
nohup plank > /dev/null 2>&1 &
