#!/bin/bash

packages="gnome firefox-esr gnome-shell-extension-dash-to-panel \
gparted vlc  flatpak cups systemd-container \
materia-gtk-theme papirus-icon-theme  neofetch \
network-manager-openvpn-gnome virt-viewer freerdp2-x11 \
gnome-games-"

httpdownloadurls="https://f5vpn.geneseo.edu/public/download/linux_f5vpn.x86_64.deb \
http://cackey.rkeene.org/download/0.7.5/cackey_0.7.5-1_amd64.deb"

username=$(cat /root/username)

apt update
apt install -y ${packages}

# Install from http links
for url in ${httpdownloadurls}; do
  # NF is the number of fields (also stands for the index of the last)
  file=$(echo ${url} | awk -F / '{print$NF}')
  wget ${url}
  dpkg -i ${file}
  rm -f ${file}
done

# Zorin Theme
git clone https://github.com/ZorinOS/zorin-desktop-themes.git
git clone https://github.com/ZorinOS/zorin-icon-themes.git
cp -r zorin-desktop-themes/Zorin* /usr/share/themes/
cp -r zorin-icon-themes/Zorin* /usr/share/icons
rm -rf zorin-desktop-themes
rm -rf zorin-icon-themes

#Yaru
#apt install -y git meson sassc libglib2.0-dev
#su ${username} -c 'cd ~ && git clone --single-branch --branch ubuntu/eoan https://github.com/ubuntu/yaru.git'
#su ${username} -c 'cd ~/yaru && meson build'
#su ${username} -c 'sudo ninja -C ~/yaru/build/ install'
#rm -rf /home/${username}/yaru

#Amarena
#su ${username} -c 'mkdir ~/Documents/build'
#su ${username} -c 'cd ~/Documents/build/ && git clone https://github.com/jaxwilko/gtk-theme-framework.git'
#su ${username} -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t amarena -d /usr/share/themes/ -p /usr/share/icons/'
#su ${username} -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t palenight -d /usr/share/themes/ -p /usr/share/icons/'
#su ${username} -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t gruvterial -d /usr/share/themes/ -p /usr/share/icons/'
#su ${username} -c 'sudo rm -rf ~/Documents/build'

su ${username} -c 'mkdir -p \$HOME/.config/autostart'
su ${username} -c 'cat > \$HOME/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=\$HOME/Documents/config.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF'
su ${username} -c 'chmod +x \$HOME/.config/autostart/script.desktop'

##Firefox title bar and flex space
cat >> /etc/firefox-esr/firefox-esr.js << EOF
pref("browser.tabs.drawInTitlebar", true);
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

##Set XORG as default session
cat > /var/lib/AccountsService/users/${username} << EOF
[User]
Language=
XSession=gnome-xorg
EOF

#disable wayland gdm
#echo 'WaylandEnable=false' >> /etc/gdm3/custom.conf

#copy config files
cp /root/* /home/${username}/Documents/
chmod +x /home/${username}/Documents/*.sh
chown -R ${username}:users /home/${username}/