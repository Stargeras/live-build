#!/bin/bash
packages="gnome firefox chromium epiphany neofetch htop gparted gnome-tweaks code ttf-droid \
        virt-viewer cups networkmanager networkmanager-openvpn transmission-gtk rhythmbox wget curl \
        celluloid gedit htop freerdp imwheel ttf-ubuntu-font-family terraform kubectl helm aws-cli"
aurpackages="yay f5vpn cackey gnome-shell-extension-dash-to-panel gnome-shell-extension-dash-to-dock \
             humanity-icon-theme yaru ubuntu-backgrounds-jammy"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)
wallpaperurl="https://149366088.v2.pressablecdn.com/wp-content/uploads/2022/03/jammy-jellyfish-wallpaper.jpg"

pacman -S ${packages} --noconfirm
systemctl enable NetworkManager
systemctl enable gdm
systemctl enable sshd
systemctl enable cups-browsed

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="\${HOME}/Documents/aur"
  su ${username} -c "mkdir -p ${aurdir}"
  su ${username} -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su ${username} -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su ${username} -c "sudo rm -rf ${aurdir}"
done

# Cleanup unneeded dependencies
pacman -Rs $(pacman -Qtdq) --noconfirm

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

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

# Download ubuntu wallpaper
wget ${wallpaperurl} -O /usr/share/backgrounds/ubuntu.jpg

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/
