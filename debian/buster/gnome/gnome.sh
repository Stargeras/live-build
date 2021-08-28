#!/bin/bash

apt update
apt install -y gnome firefox-esr \
 gparted vlc gnome-shell-extension-dash-to-panel flatpak cups\
 materia-gtk-theme papirus-icon-theme systemd-container neofetch\
 network-manager-openvpn-gnome virt-viewer freerdp2-x11\
 gnome-games-

# F5VPN
wget https://f5vpn.geneseo.edu/public/download/linux_f5vpn.x86_64.deb
dpkg -i linux_f5vpn.x86_64.deb
rm -f linux_f5vpn.x86_64.deb

# CACKEY
wget http://cackey.rkeene.org/download/0.7.5/cackey_0.7.5-1_amd64.deb
dpkg -i cackey_0.7.5-1_amd64.deb
rm -f cackey_0.7.5-1_amd64.deb

#Yaru
#apt install -y git meson sassc libglib2.0-dev
#su admin -c 'cd ~ && git clone --single-branch --branch ubuntu/eoan https://github.com/ubuntu/yaru.git'
#su admin -c 'cd ~/yaru && meson build'
#su admin -c 'sudo ninja -C ~/yaru/build/ install'
#rm -rf /home/admin/yaru

#Amarena
#su admin -c 'mkdir ~/Documents/build'
#su admin -c 'cd ~/Documents/build/ && git clone https://github.com/jaxwilko/gtk-theme-framework.git'
#su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t amarena -d /usr/share/themes/ -p /usr/share/icons/'
#su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t palenight -d /usr/share/themes/ -p /usr/share/icons/'
#su admin -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t gruvterial -d /usr/share/themes/ -p /usr/share/icons/'
#su admin -c 'sudo rm -rf ~/Documents/build'

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


