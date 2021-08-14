#!/bin/bash
pacman-key --init && pacman-key --populate
sed -i '/evowise/d' /etc/pacman.d/mirrorlist
sed -i '/CheckSpace/d' /etc/pacman.conf
pacman -Syu
pacman -S reflector --noconfirm
reflector --verbose --country 'United States' --sort rate --save /etc/pacman.d/mirrorlist
pacman -Rsn clonezilla lftp nmap openconnect --noconfirm
pacman -S bash-completion xorg-server xorg-apps xorg-xinit xdg-user-dirs base-devel git xf86-video-vesa xf86-video-vmware xf86-video-intel xf86-video-amdgpu xf86-video-nouveau --noconfirm

cat >> /etc/pacman.conf << EOF
[options]
IgnorePkg  = linux
EOF
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
# add user admin
useradd -m -g users -s /bin/bash -G wheel,storage,power admin
#allow wheel sudo
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
echo 'admin:admin' |chpasswd
echo 'root:root' | chpasswd
#add home dirs
su admin -c 'xdg-user-dirs-update '
su admin -c 'cp /etc/X11/xinit/xinitrc ~/.xinitrc'
su admin -c 'chmod +x ~/.xinitrc'
su admin -c  'sed -i "$ d" ~/.xinitrc'
#Screen resolution
cat > /etc/X11/xorg.conf << EOF
Section "Monitor"
    Identifier      "IntegratedDisplay0"
    Modeline        "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
    Option          "PreferredMode" "1920x1080_60.00"
EndSection
Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "IntegratedDisplay0"
        SubSection "Display"
                Viewport   0 0
                Depth    24
                Modes "1920x1080"
        EndSubSection
EndSection
EOF
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
systemctl set-default graphical.target

pacman -S plasma firefox chromium neofetch htop gparted print-manager \
        konsole dolphin gwenview ark kate qbittorrent celluloid \
        virt-viewer cups freerdp --noconfirm #code npm nodejs
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
#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar"],"currentVersion":17,"newElementCount":4}");
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
#lookandfeeltool -a org.kde.breezedark.desktop
#kquitapp5 plasmashell
#kstart5 plasmashell
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
