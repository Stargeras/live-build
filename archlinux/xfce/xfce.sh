#!/bin/bash
packages="pacman -S xfce4 xfce4-goodies papirus-icon-theme materia-gtk-theme firefox chromium neofetch sddm \
          pulseaudio gparted htop networkmanager network-manager-applet galculator celluloid cups \
          virt-viewer freerdp imwheel \
          inter-font ttf-opensans ttf-roboto ttf-roboto-mono ttf-droid"
aurpackages="f5vpn cackey yay"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)

pacman -S ${packages} --noconfirm
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable cups-browsed
systemctl enable sddm

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

# SDDM config
cp -r /usr/lib/sddm/sddm.conf.d /etc/
sed -i "s/Current=/Current=maldives/g" /etc/sddm.conf.d/default.conf

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/