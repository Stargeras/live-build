#!/bin/bash

packages="gnome firefox-esr neofetch ssh vim curl bash-completion virt-viewer \
gparted celluloid gnome-shell-extension-dash-to-panel flatpak cups git \
debootstrap systemd-container arch-install-scripts network-manager-openvpn-gnome \
gnome-games-"
httpdownloadurls="https://f5vpn.geneseo.edu/public/download/linux_f5vpn.x86_64.deb"
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

su ${username} -c "mkdir -p \$HOME/.config/autostart"
su ${username} -c "cat > \$HOME/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=\$HOME/Documents/config.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF"
su ${username} -c "chmod +x \$HOME/.config/autostart/script.desktop"

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

#Yaru
apt install -y git meson sassc libglib2.0-dev
su ${username} -c "cd \${HOME} && git clone https://github.com/ubuntu/yaru.git"
su ${username} -c "cd \${HOME}/yaru && meson build"
su ${username} -c "sudo ninja -C \${HOME}/yaru/build/ install"
rm -rf /home/${username}/yaru

#Material-shell
git clone https://github.com/material-shell/material-shell.git /usr/share/gnome-shell/extensions/material-shell@papyelgringo

#disable wayland gdm
#echo 'WaylandEnable=false' >> /etc/gdm3/custom.conf

cat >> /home/${username}/Documents/adwaita.sh << EOF
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/adwaita-timed.xml'
gsettings set org.gnome.shell enabled-extensions "['']"
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
EOF

#copy config files
cp /root/* /home/${username}/Documents/
chmod +x /home/${username}/Documents/*.sh
chown -R ${username}:users /home/${username}/