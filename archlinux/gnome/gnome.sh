#!/bin/bash
pacman-key --init && pacman-key --populate
sed -i '/evowise/d' /etc/pacman.d/mirrorlist
sed -i '/CheckSpace/d' /etc/pacman.conf
pacman -Syu
pacman -S reflector --noconfirm
reflector --verbose --country 'United States' --sort rate --save /etc/pacman.d/mirrorlist
pacman -Rsn clonezilla lftp nmap openconnect --noconfirm
pacman -S bash-completion xorg-server xorg-apps xorg-xinit xdg-user-dirs base-devel git xf86-video-vesa xf86-video-vmware xf86-video-intel xf86-video-amdgpu xf86-video-nouveau --noconfirm

cat >> /etc/pacman.conf << EOF
[options]
IgnorePkg  = linux
EOF
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
# add user admin
useradd -m -g users -s /bin/bash -G wheel,storage,power admin
#allow wheel sudo
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
echo 'admin:admin' |chpasswd
echo 'root:root' | chpasswd
#add home dirs
su admin -c 'xdg-user-dirs-update '
su admin -c 'cp /etc/X11/xinit/xinitrc ~/.xinitrc'
su admin -c 'chmod +x ~/.xinitrc'
su admin -c  'sed -i "$ d" ~/.xinitrc'
#Screen resolution
cat > /etc/X11/xorg.conf << EOF
Section "Monitor"
    Identifier      "IntegratedDisplay0"
    Modeline        "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
    Option          "PreferredMode" "1920x1080_60.00"
EndSection
Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "IntegratedDisplay0"
        SubSection "Display"
                Viewport   0 0
                Depth    24
                Modes "1920x1080"
        EndSubSection
EndSection
EOF
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
systemctl set-default graphical.target

mv /etc/motd /etc/motd.bak   
pacman -S gnome-session gnome-tweaks gnome-terminal gnome-backgrounds gnome-calculator \
        gnome-control-center nautilus bluez gdm pulseaudio firefox chromium neofetch htop gparted \
        virt-viewer cups networkmanager-openvpn networkmanager transmission-gtk rhythmbox \
        celluloid gedit htop eog freerdp --noconfirm #code npm nodejs deepin-community-wallpapers
systemctl enable NetworkManager
systemctl enable gdm
systemctl enable sshd
systemctl enable cups-browsed
# #yaru
pacman -S ninja meson sassc --noconfirm
su admin -c 'mkdir ~/Documents/build'
su admin -c 'cd ~/Documents/build && git clone https://github.com/ubuntu/yaru.git'
su admin -c 'cd ~/Documents/build/yaru/ && sudo ./bootstrap.sh -b'

su admin -c 'cd ~/Documents/build/ && git clone https://github.com/jaxwilko/gtk-theme-framework.git'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t amarena -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t palenight -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t gruvterial -d /usr/share/themes/ -p /usr/share/icons/'

su admin -c 'cd ~/Documents/build/ && git clone https://aur.archlinux.org/gnome-shell-extension-dash-to-panel.git'
su admin -c 'cd ~/Documents/build/gnome-shell-extension-dash-to-panel/ && makepkg -si --noconfirm'
su admin -c 'sudo rm -rf ~/Documents/build/'


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
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'chromium.desktop', 'nautilus.desktop', 'gnome-terminal.desktop']"
#gsettings set org.gnome.shell enabled-extensions "['dash-to-panel@jderose9.github.com']"
#gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ list-recursively org.gnome.shell.extensions.dash-to-panel
#gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel panel-size 40
#gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel animate-show-apps false
#gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-margin 3
#gsettings --schemadir /usr/share/gnome-shell/extensions/dash-to-panel@jderose9.github.com/schemas/ set org.gnome.shell.extensions.dash-to-panel appicon-padding 3
#dconf write /org/gnome/shell/extensions/dash-to-panel/show-window-previews false
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
#VPN
if [ ! -f "/home/admin/Documents/vpn_created" ]; then
    nmcli connection import type openvpn file /home/admin/Documents/expressvpn-newyork.ovpn;
    nmcli connection modify expressvpn-newyork vpn.user-name en48zqlgxnrbde1cqdrehvcd;
    nmcli connection modify expressvpn-newyork vpn.secrets password=pahs4pueovqcuqt4k67zzx3n;
    touch /home/admin/Documents/vpn_created;
fi
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

cat > /home/admin/Documents/network.sh << FOE
nmcli connection add con-name con1 ipv4.addresses 10.37.19.77/24 ipv4.gateway 10.37.19.1 ipv4.dns 10.37.19.11,10.181.0.12 type ethernet ipv4.method manual connection.interface-name ""
nmcli con up con1
cat >> /etc/hosts << DUN
10.37.19.10 rhv-engine.of.bsil
10.37.19.109 rhel109.of.bsil rhel109
10.37.19.110 rhel110.of.bsil rhel110
10.37.19.103 rhel103.of.bsil rhel103
10.37.19.50 rhv-engine.ofint.bsil
10.37.19.114 rhel114.ofint.bsil rhel114
10.37.19.115 rhel115.ofint.bsil rhel115
10.37.19.116 rhel116.ofint.bsil rhel116
10.37.19.108 rhel108.ofint.bsil rhel108
DUN
FOE

cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/
