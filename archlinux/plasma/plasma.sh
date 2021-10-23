#!/bin/bash
packages="plasma firefox chromium neofetch htop gparted print-manager \
        konsole dolphin gwenview ark kate qbittorrent celluloid imwheel \
        virt-viewer cups freerdp code ttf-droid"
aurpackages="f5vpn cackey yay"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)
usechromiummods="true"

pacman -S ${packages} --noconfirm #code npm nodejs
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable sddm
systemctl enable cups-browsed

#su ${username} -c 'echo "exec startplasma-x11" >> ~/.xinitrc'
#sddm
cp -r /usr/lib/sddm/sddm.conf.d /etc/
sed -i "s/Current=/Current=breeze/g" /etc/sddm.conf.d/default.conf
sed -i "s/CursorTheme=/CursorTheme=breeze_cursors/g" /etc/sddm.conf.d/default.conf

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

cat > /etc/xdg/dolphinrc << EOF
[General]
Version=200

[MainWindow]
Height 1080=670
MenuBar=Disabled
State=AAAA/wAAAAD9AAAAAwAAAAAAAAC4AAABzvwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAA/////wAAAAoBAAAD+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAmAAABzgAAAF0BAAADAAAAAQAAAAAAAAAA/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAAD/////AAAACgEAAAMAAAADAAAAAAAAAAD8AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAA/////wAAAAoBAAADAAACNQAAAc4AAAAEAAAABAAAAAgAAAAI/AAAAAEAAAACAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAQAAAAD/////AAAAAAAAAAA=
ToolBarsMovable=Disabled
Width 1920=1187
EOF

mkdir -p /home/${username}/.config/autostart
cat > /home/${username}/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=sh ${builddir}/config.sh
Terminal=false
Type=Application
EOF
chmod +x /home/${username}/.config/autostart/script.desktop

# Run Chromium customizations
if ${usechromiummods}; then
  bash ${builddir}/chromium_custom.sh
  sed -i 's/"use_system": true/"use_system": false/g' ${builddir}/chromium_custom.sh
fi

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/

# cat > /etc/xdg/kactivitymanagerd-statsrc << EOF
# [Favorites-org.kde.plasma.kickoff.favorites.instance-3-global]
# ordering=chromium.desktop,firefox.desktop,systemsettings.desktop,org.kde.dolphin.desktop,org.kde.kate.desktop,org.kde.konsole.desktop
# EOF

# cat > /etc/xdg/kactivitymanagerdrc << EOF
# [activities]
# global=Default

# [main]
# currentActivity=global
# EOF

#kwriteconfig5 --file kactivitymanagerd-statsrc --group Favorites-org.kde.plasma.kickoff.favorites.instance-3-global --key ordering chromium.desktop,firefox.desktop,systemsettings.desktop,org.kde.dolphin.desktop,org.kde.kate.desktop,org.kde.konsole.desktop
#kwriteconfig5 --file kactivitymanagerdrc --group activities --key global Default
#kwriteconfig5 --file kactivitymanagerdrc --group main --key currentActivity global
