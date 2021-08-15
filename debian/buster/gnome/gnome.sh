#!/bin/bash

cat >> /etc/apt/sources.list << EOF
deb [trusted=yes] http://23.82.1.13/deb/ buster main
EOF

apt update
apt install -y gnome firefox-esr neofetch ssh vim curl bash-completion\
 gparted vlc gnome-shell-extension-dash-to-panel flatpak cups git\
 materia-gtk-theme papirus-icon-theme debootstrap systemd-container\
 arch-install-scripts network-manager-openvpn-gnome virt-viewer freerdp2-x11\
 google-chrome-stable f5vpn cackey gnome-games-

apt update
apt upgrade -y
systemctl disable unattended-upgrades
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
cat >> /etc/bash.bashrc << EOF
alias ls='ls --color=auto'
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
alias weather='curl wttr.in/21009+us'
#needs youtube-dl
alias ytdm='youtube-dl --extract-audio --audio-format mp3'
alias ytdv='youtube-dl -f bestvideo+bestaudio'
EOF
echo 'debian10' > /etc/hostname
echo "color slate" >> /etc/vim/vimrc

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

useradd -m -g users -s /bin/bash -G sudo,netdev,disk admin
cat >> /etc/sudoers << EOF
%sudo ALL=(ALL) NOPASSWD: ALL
EOF
echo 'admin:admin' |chpasswd
echo 'root:root' | chpasswd
#add home dirs
su admin -c 'xdg-user-dirs-update'

#Yaru
: `
apt install -y git meson sassc libglib2.0-dev
su admin -c 'cd ~ && git clone --single-branch --branch ubuntu/eoan https://github.com/ubuntu/yaru.git'
su admin -c 'cd ~/yaru && meson build'
su admin -c 'sudo ninja -C ~/yaru/build/ install'
rm -rf /home/admin/yaru
`
#Amarena
: `
su admin -c 'mkdir ~/Documents/build'
su admin -c 'cd ~/Documents/build/ && git clone https://github.com/jaxwilko/gtk-theme-framework.git'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t amarena -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t palenight -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t gruvterial -d /usr/share/themes/ -p /usr/share/icons/'
su admin -c 'sudo rm -rf ~/Documents/build'
`


su admin -c 'mkdir -p ~/.config/autostart'
su admin -c 'cat > ~/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=/home/admin/Documents/config.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF'
su admin -c 'chmod +x ~/.config/autostart/script.desktop'

##Firefox title bar and flex space
cat >> /etc/firefox-esr/firefox-esr.js << EOF
pref("browser.tabs.drawInTitlebar", true);
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

##Set XORG as default session
cat > /var/lib/AccountsService/users/admin << EOF
[User]
Language=
XSession=gnome-xorg
EOF

#disable wayland gdm
#echo 'WaylandEnable=false' >> /etc/gdm3/custom.conf

#copy config files
cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/

