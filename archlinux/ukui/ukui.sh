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

mv /etc/motd /etc/motd.bak
pacman -S ukui neofetch firefox htop gparted networkmanager \
        pulseaudio firefox chromium neofetch htop gparted eog gedit gnome-terminal \
        virt-viewer cups networkmanager-openvpn transmission-gtk rhythmbox \
        celluloid --noconfirm #code npm nodejs
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable lightdm
systemctl enable cups-browsed

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF


cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/
