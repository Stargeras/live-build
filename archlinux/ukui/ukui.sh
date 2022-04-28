#!/bin/bash
packages="ukui neofetch firefox chromium htop gparted networkmanager \
        pulseaudio htop gparted eog gedit gnome-terminal terraform helm kubectl \
        virt-viewer cups networkmanager-openvpn transmission-gtk rhythmbox celluloid"
aurpackages="yay f5vpn cackey"
enabledservices="NetworkManager sshd lightdm cups-browsed"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)

pacman -S ${packages} --noconfirm

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="\${HOME}/Documents/aur"
  su ${username} -c "mkdir -p ${aurdir}"
  su ${username} -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su ${username} -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su ${username} -c "sudo rm -rf ${aurdir}"
done

# Enable services
for service in ${enabledservices}; do
  systemctl enable ${service}
done

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

# Cleanup unneeded dependencies
pacman -Rs $(pacman -Qtdq) --noconfirm

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/
