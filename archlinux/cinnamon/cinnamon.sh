#!/bin/bash
packages="cinnamon nemo-fileroller lightdm lightdm-gtk-greeter firefox chromium neofetch htop gparted celluloid gnome-terminal gedit \
          virt-viewer freerdp imwheel cups vim curl gnome-screenshot eog code archlinux-wallpaper \
          noto-fonts inter-font ttf-opensans ttf-roboto ttf-roboto-mono ttf-droid"
aurpackages="f5vpn cackey yay orchis-theme-git tela-circle-icon-theme-git breeze-hacked-cursor-theme-git"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)
usechromiummods="true"

pacman -S ${packages} --noconfirm
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable lightdm

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

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

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

# Lightdm mods
cat >> /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=lightdm-gtk-greeter
EOF
cat >> /etc/lightdm/lightdm-gtk-greeter.conf << EOF
background=/usr/share/backgrounds/archlinux/gritty.png
EOF

# Run Chromium customizations
if ${usechromiummods}; then
  sed -i 's/"use_system": true/"use_system": false/g' ${builddir}/chromium_custom.sh
  bash ${builddir}/chromium_custom.sh
fi

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/
