#!/bin/bash
gsettings set org.gnome.desktop.interface gtk-theme  'io.elementary.stylesheet.banana'
gsettings set org.gnome.desktop.interface icon-theme 'elementary'
gsettings set org.gnome.desktop.interface cursor-theme 'elementary'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close:maximize'
gsettings set org.pantheon.desktop.gala.animations enable-animations 'true'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/odin.jpg'
gsettings set org.gnome.desktop.interface clock-format 12h
#dconf write /net/launchpad/plank/docks/dock1/hide-mode "'none'"
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Terminal font
dconf write /org/gnome/desktop/interface/monospace-font-name "'Liberation Mono 11'"

###PLANK DOCK
killall plank
# App names are in /usr/share/applications without .desktop extension
dockitems="firefox chromium io.elementary.files io.elementary.terminal io.elementary.code io.elementary.switchboard"
dockpath="${HOME}/.config/plank/dock1/launchers"
dconfstring=""
rm -f ${dockpath}/*
for item in ${dockitems}; do
  cat > ${dockpath}/${item}.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/${item}.desktop
FOE
  dconfstring+="'${item}.dockitem', "
done 
dconf write /net/launchpad/plank/docks/dock1/dock-items "[${dconfstring::-2}]"
nohup plank > /dev/null 2>&1 &
