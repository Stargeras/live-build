#!/bin/bash

builddir="/srv/build-files"
username=$(cat ${builddir}/username)
defaultresolution=$(cat ${builddir}/defaultresolution)
timezone=$(cat ${builddir}/localtime)
packages="xserver-xorg-core xdg-user-dirs sudo ssh vim curl bash-completion git debootstrap arch-install-scripts \
firmware-realtek firmware-misc-nonfree firmware-libertas firmware-iwlwifi firmware-intelwimax firmware-linux"

apt update
apt install -y ${packages}

#apt update
#apt upgrade -y
systemctl disable unattended-upgrades

# SET TIMEZONE
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime

# OTHER CUSTOMIZATIONS
cat >> /etc/bash.bashrc << EOF
alias ls='ls --color=auto'
alias ll='ls -l'
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
#needs youtube-dl
alias ytdm='youtube-dl --extract-audio --audio-format mp3'
alias ytdv='youtube-dl -f bestvideo+bestaudio'
EOF
cp /etc/skel/.bashrc /root/
echo debian-$(cat /etc/apt/sources.list | head -1 | awk '{print$3}') > /etc/hostname

# SET DEFAULT RESOLUTION
cat > /etc/X11/xorg.conf << EOF
Section "Monitor"
    Identifier      "IntegratedDisplay0"
    Modeline        $(cvt ${defaultresolution} | grep Modeline | cut -f 2- -d ' ')
    Option          "PreferredMode" $(cvt ${defaultresolution} | grep Modeline | awk '{print$2}')
EndSection
Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "IntegratedDisplay0"
        SubSection "Display"
                Viewport   0 0
                Depth    24
                Modes $(cvt ${defaultresolution} | grep Modeline | awk '{print$2}')
        EndSubSection
EndSection
EOF

useradd -m -g users -s /bin/bash -G sudo,netdev,disk ${username}
cat >> /etc/sudoers << EOF
%sudo ALL=(ALL) NOPASSWD: ALL
EOF
echo "${username}:${username}" |chpasswd
echo 'root:root' | chpasswd
#add home dirs
su ${username} -c 'xdg-user-dirs-update'

# VIM CUSTOMIZATIONS
cat >> /home/${username}/.vimrc << EOF
syntax on
colorscheme slate
set mouse=v
EOF
chown ${username}:users /home/${username}/.vimrc
cp /home/${username}/.vimrc /root/

# ADD AUTHORIZED_KEYS
mkdir /root/.ssh
mkdir /home/${username}/.ssh
cp ${builddir}/authorized_keys /root/.ssh/
cp ${builddir}/authorized_keys /home/${username}/.ssh/
chown -R ${username}:users /home/${username}/.ssh
