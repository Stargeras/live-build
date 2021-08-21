#!/bin/bash
packages="gnome firefox chromium neofetch htop gparted gnome-tweaks code ttf-droid \
        virt-viewer cups networkmanager networkmanager-openvpn transmission-gtk rhythmbox \
        celluloid gedit htop freerdp"
#packages="gnome-session gnome-tweaks gnome-terminal gnome-backgrounds gnome-calculator gnome-control-center nautilus bluez gdm pulseaudio firefox chromium neofetch htop gparted virt-viewer cups networkmanager-openvpn networkmanager transmission-gtk rhythmbox celluloid gedit htop eog freerdp"
aurpackages="f5vpn cackey gnome-shell-extension-dash-to-panel"
pacman -S ${packages} --noconfirm #code npm nodejs deepin-community-wallpapers
systemctl enable NetworkManager
systemctl enable gdm
systemctl enable sshd
systemctl enable cups-browsed

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="~/Documents/build"
  su admin -c "mkdir -p ${aurdir}"
  su admin -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su admin -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su admin -c "sudo rm -rf ${aurdir}"
done

# #yaru
pacman -S ninja meson sassc --noconfirm
su admin -c 'mkdir ~/Documents/build'
su admin -c 'cd ~/Documents/build && git clone https://github.com/ubuntu/yaru.git'
su admin -c 'cd ~/Documents/build/yaru/ && sudo ./bootstrap.sh -b'

su admin -c 'cd ~/Documents/build/ && git clone https://github.com/jaxwilko/gtk-theme-framework.git'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t amarena -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t palenight -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t gruvterial -d /usr/share/themes/ -p /usr/share/icons/'

# su admin -c 'cat >> ~/.bashrc << EOF
# export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
# EOF'


cat > /home/admin/Documents/config.sh << EOF
gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
#gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:appmenu"
gsettings set org.gnome.desktop.interface enable-animations false
#gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/SeaSunset.jpg'
#DARK THEME
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant dark
#THEME
#gsettings set org.gnome.desktop.interface gtk-theme 'amarena'
#gsettings set org.gnome.desktop.interface icon-theme 'amarena'
#gsettings set org.gnome.desktop.interface cursor-theme 'amarena'
#Nautilus size
gsettings set org.gnome.nautilus.window-state initial-size '(1050, 560)'
#Terminal size
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 27
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 122
#Dash to panel
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'nautilus.desktop', 'gnome-terminal.desktop']"
gsettings set org.gnome.shell enabled-extensions "['dash-to-panel@jderose9.github.com']"
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ list-recursively org.gnome.shell.extensions.dash-to-panel
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-size 40
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-show-apps false
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-margin 3
gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-padding 3
dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Super>e'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'nautilus --new-window'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'Nautilus'"
# Terminal font
dconf write /org/gnome/desktop/interface/monospace-font-name "'Liberation Mono 11'"
#clock format
sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
gsettings set org.gnome.desktop.interface clock-format 12h
#disable suspend
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
#touchpad
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
EOF

mkdir -p /home/admin/.config/autostart
cat > /home/admin/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=/home/admin/Documents/config.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF
chmod +x /home/admin/.config/autostart/script.desktop

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

##Set XORG as default session
cat > /var/lib/AccountsService/users/admin << EOF
[User]
Language=
XSession=gnome-xorg
EOF

cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/
