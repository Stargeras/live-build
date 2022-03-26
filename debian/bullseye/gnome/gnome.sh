#!/bin/bash

packages="gnome firefox-esr chromium epiphany-browser neofetch imwheel \
gparted celluloid gnome-shell-extension-dash-to-panel cups awscli dnsutils \
systemd-container network-manager-openvpn-gnome virt-viewer freerdp2-x11 \
gnome-games-"
httpdownloadurls="https://f5vpn.geneseo.edu/public/download/linux_f5vpn.x86_64.deb \
http://cackey.rkeene.org/download/0.7.5/cackey_0.7.5-1_amd64.deb"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)

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

# Fedora background
url="https://github.com/fedoradesign/backgrounds/releases/download/v34.0.1/f34-backgrounds-34.0.1.tar.xz"
file=$(echo ${url} | awk -F / '{print$NF}')
wget ${url}
tar xvf ${file}
mkdir /usr/share/backgrounds/$(echo ${file} | awk -F - '{print$1}')
cp -r $(echo ${file} | awk -F - '{print$1,"-",$2}' | sed "s/ //g")/default /usr/share/backgrounds/$(echo ${file} | awk -F - '{print$1}')
rm -rf $(echo ${file} | awk -F - '{print$1,"-",$2}' | sed "s/ //g")*


mkdir -p /home/${username}/.config/autostart
cat > /home/${username}/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=${builddir}/config.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF
chmod +x /home/${username}/.config/autostart/script.desktop

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

# Zorin Theme
git clone https://github.com/ZorinOS/zorin-desktop-themes.git
git clone https://github.com/ZorinOS/zorin-icon-themes.git
cp -r zorin-desktop-themes/Zorin* /usr/share/themes/
cp -r zorin-icon-themes/Zorin* /usr/share/icons
rm -rf zorin-desktop-themes
rm -rf zorin-icon-themes

# Material-shell
#git clone https://github.com/material-shell/material-shell.git /usr/share/gnome-shell/extensions/material-shell@papyelgringo
url="https://github.com/material-shell/material-shell/archive/refs/tags/12.zip"
file=$(echo ${url} | awk -F / '{print$NF}')
dir="/usr/share/gnome-shell/extensions/material-shell@papyelgringo"
mkdir ${dir}
wget ${url}
unzip ${file} -d $(echo ${file} | awk -F . '{print $1}')
mv $(echo ${file} | awk -F . '{print $1}')/$(ls $(echo ${file} | awk -F . '{print $1}'))/* ${dir}/
rm -rf $(echo ${file} | awk -F . '{print $1}')*

#disable wayland gdm
#echo 'WaylandEnable=false' >> /etc/gdm3/custom.conf

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/
