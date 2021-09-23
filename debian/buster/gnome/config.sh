gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
#gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:appmenu"
gsettings set org.gnome.desktop.interface enable-animations false
#gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/desktop-base/futureprototype-theme/wallpaper-withlogo/gnome-background.xml'
#gsettings set org.gnome.desktop.interface gtk-theme 'amarena'
#gsettings set org.gnome.desktop.interface icon-theme 'amarena'
#gsettings set org.gnome.desktop.interface cursor-theme 'amarena'
#DARK THEME
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant dark
#Nautilus size
gsettings set org.gnome.nautilus.window-state initial-size '(1050, 560)'
#Terminal size
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 30
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 122
#Extensions
gsettings set org.gnome.shell favorite-apps "['firefox-esr.desktop', 'nautilus.desktop', 'gnome-terminal.desktop']"
gsettings set org.gnome.shell enabled-extensions "['dash-to-panel@jderose9.github.com']"
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ list-recursively org.gnome.shell.extensions.dash-to-panel
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-size 43
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-show-apps false
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-margin 3
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-padding 3
dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
dconf write /org/gnome/shell/extensions/dash-to-panel/trans-use-custom-opacity true
dconf write /org/gnome/shell/extensions/dash-to-panel/trans-panel-opacity 1.0
#clock format
sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
gsettings set org.gnome.desktop.interface clock-format 12h
#disable suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
#touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
#gedit
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
#VNC
#dconf write /org/gnome/settings-daemon/plugins/sharing/vino-server/enabled-connections ["'"$(nmcli -t -f UUID connection show --active)"'"]
#gsettings set org.gnome.Vino authentication-methods ['vnc']
#gsettings set org.gnome.Vino prompt-enabled false
#gsettings set org.gnome.Vino vnc-password 'YWRtaW4='
#gsettings set org.gnome.Vino require-encryption false
#VM resolution tool
#if xrandr --listmonitors | grep Virtual; then gnome-terminal -- ~/Documents/restool.sh; fi
#SSH fix
#sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
#sudo systemctl restart sshd
