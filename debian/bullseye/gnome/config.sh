gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
gsettings set org.gnome.desktop.interface enable-animations false
#gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/desktop-base/joy-inksplat-theme/wallpaper/gnome-background.xml'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/adwaita-timed.xml'
# GEDIT
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
#Nautilus
gsettings set org.gnome.nautilus.window-state initial-size '(1119, 604)'
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'small'
#Terminal
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant dark
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/bold-is-bright 'true'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 33
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 123
# Epiphany browser
dconf write /org/gnome/epiphany/state/window-size '(1600, 900)'
gsettings set org.gnome.Epiphany default-search-engine 'Google'
gsettings set org.gnome.Epiphany restore-session-policy 'crashed'
#Extensions
#Dash-to-panel
gsettings set org.gnome.shell favorite-apps "['epiphany.desktop', 'nautilus.desktop', 'gnome-terminal.desktop']"
gsettings set org.gnome.shell enabled-extensions "['dash-to-panel@jderose9.github.com']"
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ list-recursively org.gnome.shell.extensions.dash-to-panel
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-size 40
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-show-apps false
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-margin 3
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-padding 3
dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
#Material-shell
#gsettings set org.gnome.shell favorite-apps "['firefox-esr.desktop', 'chromium.desktop', 'nautilus.desktop', 'gnome-terminal.desktop']"
#gsettings set org.gnome.shell enabled-extensions "['material-shell@papyelgringo']"
#gsettings set org.gnome.desktop.notifications show-banners false
#dconf write /org/gnome/shell/extensions/materialshell/theme/panel-icon-style "'category'"
#dconf write /org/gnome/shell/extensions/materialshell/theme/panel-size "40"
#dconf write /org/gnome/shell/extensions/materialshell/layouts/split "false"
#dconf write /org/gnome/shell/extensions/materialshell/layouts/half "false"
#dconf write /org/gnome/shell/extensions/materialshell/layouts/grid "true"
#dconf write /org/gnome/shell/extensions/materialshell/layouts/tween-time "0.0"
#dconf write /org/gnome/shell/extensions/materialshell/layouts/gap "10"
#dconf write /org/gnome/shell/extensions/materialshell/theme/blur-background "true"
#dconf write /org/gnome/shell/extensions/materialshell/theme/horizontal-panel-position "'bottom'"
#dconf write /org/gnome/shell/extensions/materialshell/bindings/cycle-tiling-layout "['<Super>f']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Super>e'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'nautilus --new-window'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Nautilus'"
#clock format
sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
gsettings set org.gnome.desktop.interface clock-format 12h
#disable suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
#touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
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