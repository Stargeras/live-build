#!/bin/bash

packages="xdg-user-dirs sudo ssh vim curl bash-completion git debootstrap arch-install-scripts"

#cat >> /etc/apt/sources.list << EOF
#private
#deb [trusted=yes] http://23.82.1.13/deb/ buster main
#vscode
#deb [arch=amd64,arm64,armhf] http://packages.microsoft.com/repos/code stable main
#google-chrome
#deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main
#EOF

apt update
apt install -y ${packages}

#apt update
#apt upgrade -y
systemctl disable unattended-upgrades
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
cat >> /etc/bash.bashrc << EOF
alias ls='ls --color=auto'
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
alias weather='curl wttr.in/21009+us'
#needs youtube-dl
alias ytdm='youtube-dl --extract-audio --audio-format mp3'
alias ytdv='youtube-dl -f bestvideo+bestaudio'
EOF
echo debian-$(cat /etc/apt/sources.list | head -1 | awk '{print$3}') > /etc/hostname
echo "color slate" >> /etc/vim/vimrc

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

useradd -m -g users -s /bin/bash -G sudo,netdev,disk admin
cat >> /etc/sudoers << EOF
%sudo ALL=(ALL) NOPASSWD: ALL
EOF
echo 'admin:admin' |chpasswd
echo 'root:root' | chpasswd
#add home dirs
su admin -c 'xdg-user-dirs-update'
