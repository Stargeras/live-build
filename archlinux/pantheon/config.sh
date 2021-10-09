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
rm -f ${HOME}/.config/plank/dock1/launchers/*
cat > ${HOME}/.config/plank/dock1/launchers/firefox.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/firefox.desktop
FOE
cat > ${HOME}/.config/plank/dock1/launchers/io.elementary.files.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/io.elementary.files.desktop
FOE
cat > ${HOME}/.config/plank/dock1/launchers/io.elementary.terminal.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/io.elementary.terminal.desktop
FOE
cat > ${HOME}/.config/plank/dock1/launchers/io.elementary.calendar.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/io.elementary.calendar.desktop
FOE
cat > ${HOME}/.config/plank/dock1/launchers/io.elementary.code.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/io.elementary.code.desktop
FOE
cat > ${HOME}/.config/plank/dock1/launchers/io.elementary.switchboard.dockitem << FOE
[PlankDockItemPreferences]
Launcher=file:///usr/share/applications/io.elementary.switchboard.desktop
FOE
dconf write /net/launchpad/plank/docks/dock1/dock-items "['firefox.dockitem', 'io.elementary.files.dockitem', 'io.elementary.terminal.dockitem', 'io.elementary.calendar.dockitem', 'io.elementary.code.dockitem', 'io.elementary.switchboard.dockitem']"
plank &
