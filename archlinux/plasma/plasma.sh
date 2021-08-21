#!/bin/bash
packages="plasma firefox chromium neofetch htop gparted print-manager \
        konsole dolphin gwenview ark kate qbittorrent celluloid \
        virt-viewer cups freerdp code ttf-droid"
aurpackages="f5vpn cackey"

pacman -S ${packages} --noconfirm #code npm nodejs
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable sddm
systemctl enable cups-browsed
su admin -c 'cat >> ~/.bashrc << EOF
export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
EOF'
su admin -c 'echo "exec startplasma-x11" >> ~/.xinitrc'
#sddm
cp -r /usr/lib/sddm/sddm.conf.d /etc/
sed -i "s/Current=/Current=breeze/g" /etc/sddm.conf.d/default.conf
sed -i "s/CursorTheme=/CursorTheme=breeze_cursors/g" /etc/sddm.conf.d/default.conf

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="~/Documents/build"
  su admin -c "mkdir -p ${aurdir}"
  su admin -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su admin -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su admin -c "sudo rm -rf ${aurdir}"
done

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

cat > /etc/xdg/konsolerc << EOF
[MainWindow]
Height 1080=670
Width 1920=1187
EOF

cat > /home/admin/Documents/config.sh << EOF
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'SELECT * FROM ResourceLink;'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'DELETE FROM ResourceLink;'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:chromium.desktop");'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:firefox.desktop");'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:org.kde.dolphin.desktop");'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:org.kde.konsole.desktop");'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:org.kde.kate.desktop");'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:systemsettings.desktop");'

#kwriteconfig5 --file plasmarc --group Theme --key name breeze-dark
#kwriteconfig5 --file kdeglobals --group General --key ColorScheme "Breeze Dark"
#kwriteconfig5 --file kdeglobals --group General --key Name breeze-dark
#kwriteconfig5 --file kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezedark.desktop
#kwriteconfig5 --file kdeglobals --group icons --key Theme breeze-dark
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-theme-name "Breeze Dark"
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name breeze-dark
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-application-prefer-dark-theme true
lookandfeeltool -a org.kde.breezedark.desktop
kquitapp5 plasmashell
kstart5 plasmashell
EOF
chmod +x /home/admin/Documents/config.sh

mkdir -p /home/admin/.config/autostart
cat > /home/admin/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=sh /home/admin/Documents/config.sh
Terminal=false
Type=Application
EOF
chmod +x /home/admin/.config/autostart/script.desktop

cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/

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
