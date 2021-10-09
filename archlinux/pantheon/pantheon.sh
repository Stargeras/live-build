#!/bin/bash
packages="pantheon firefox chromium neofetch htop gparted celluloid \
          virt-viewer freerdp code"
aurpackages="f5vpn cackey"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)

pacman -S ${packages} --noconfirm
systemctl enable NetworkManager
systemctl enable sshd

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="\${HOME}/Documents/aur"
  su ${username} -c "mkdir -p ${aurdir}"
  su ${username} -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su ${username} -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su ${username} -c "sudo rm -rf ${aurdir}"
done

cat >> /home/${username}/.bashrc << EOF
export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
EOF

cat >> /home/${username}/.xinitrc << EOF
io.elementary.wingpanel &
plank &
exec gala
EOF

#sddm
#cp -r /usr/lib/sddm/sddm.conf.d /etc/
#sed -i "s/Current=/Current=breeze/g" /etc/sddm.conf.d/default.conf
#sed -i "s/CursorTheme=/CursorTheme=breeze_cursors/g" /etc/sddm.conf.d/default.conf

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
