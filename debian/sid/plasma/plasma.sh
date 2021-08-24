#!/bin/bash

#cat >> /etc/apt/sources.list << EOF
#private
#deb [trusted=yes] http://23.82.1.13/deb/ buster main
#vscode
#deb [arch=amd64,arm64,armhf] http://packages.microsoft.com/repos/code stable main
#google-chrome
#deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
#EOF


apt update
apt install -y plasma-desktop sddm konsole dolphin kate ssh firefox-esr chromium cackey\
 gparted celluloid flatpak cups git neofetch vim curl gparted bash-completion\
 debootstrap systemd-container arch-install-scripts network-manager-openvpn-gnome\
 virt-viewer
 #slack-desktop doesn't work

systemctl disable unattended-upgrades
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

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

cat >> /etc/bash.bashrc << EOF
alias ls='ls --color=auto'
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
alias weather='curl wttr.in/21009+us'
#needs youtube-dl
alias ytdm='youtube-dl --extract-audio --audio-format mp3'
alias ytdv='youtube-dl -f bestvideo+bestaudio'
EOF
echo 'debian' > /etc/hostname
echo "color slate" >> /etc/vim/vimrc

useradd -m -g users -s /bin/bash -G sudo,netdev,disk admin
cat >> /etc/sudoers << EOF
%sudo ALL=(ALL) NOPASSWD: ALL
EOF
echo 'admin:admin' |chpasswd
echo 'root:root' | chpasswd

#add home dirs
su admin -c 'xdg-user-dirs-update'

su admin -c 'mkdir -p ~/.config/autostart'
cat > /home/admin/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=sh /home/admin/Documents/config.sh
Terminal=false
Type=Application
EOF
su admin -c 'chmod +x ~/.config/autostart/script.desktop'

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

# F5VPN
wget https://f5vpn.geneseo.edu/public/download/linux_f5vpn.x86_64.deb
dpkg -i linux_f5vpn.x86_64.deb
rm -f linux_f5vpn.x86_64.deb

##Firefox title bar and flex space
cat >> /etc/firefox-esr/firefox-esr.js << EOF
pref("browser.tabs.drawInTitlebar", true);
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

#copy config files
cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/
