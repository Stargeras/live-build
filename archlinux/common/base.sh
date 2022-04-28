#!/bin/bash

builddir="/srv/build-files"
username=$(cat ${builddir}/username)
defaultresolution=$(cat ${builddir}/defaultresolution)
timezone=$(cat ${builddir}/localtime)
packages="base-devel git bash-completion \
xorg-server xorg-apps xorg-xinit xdg-user-dirs open-vm-tools \
xf86-video-vesa xf86-video-vmware xf86-video-intel xf86-video-amdgpu xf86-video-nouveau"

# PACMAN INIT
pacman-key --init && pacman-key --populate

# REMOVE BROKEN MIRRORS
brokenmirrors="evowise"
for mirror in ${brokenmirrors}; do
  sed -i "/${mirror}/d" /etc/pacman.d/mirrorlist
done

# FIX PACMAN SPACE ERROR
sed -i '/CheckSpace/d' /etc/pacman.conf
pacman -Syu --noconfirm

# USE REFLECTOR TO RATE MIRRORS
pacman -S reflector --noconfirm
reflector --verbose --country 'United States' --sort rate --save /etc/pacman.d/mirrorlist

# INSTALL PACKAGES
pacman -Rsn clonezilla lftp nmap openconnect --noconfirm
pacman -S ${packages} --noconfirm

# ADD KERNEL TO PACMAN EXCEPTION
cat >> /etc/pacman.conf << EOF
[options]
IgnorePkg  = linux
EOF

# SET TIMEZONE
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime

# CREATE USER ACCOUNT
useradd -m -g users -s /bin/bash -G wheel,storage,power ${username}

# ALLOW WHEEL SUDO
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# SET DEFAULT PWS
echo "${username}:${username}" |chpasswd
echo 'root:root' | chpasswd

# CREATE HOME DIRS
su ${username} -c "xdg-user-dirs-update"
cp /etc/X11/xinit/xinitrc /home/${username}/.xinitrc
sed -i "$ d" /home/${username}/.xinitrc
chmod +x /home/${username}/.xinitrc
chown ${username}:users /home/${username}/.xinitrc

# ADD BASHRC CUSTOMIZATIONS
cat >> /etc/bash.bashrc << EOF
alias ls='ls --color=auto'
alias ll='ls -l'
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
#export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
# Debian colors
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF

cat >> /home/${username}/.bashrc << EOF
alias ls='ls --color=auto'
alias ll='ls -l'
alias ram='ps axch -o cmd:15,%mem --sort=-%mem | head'
alias cpu='ps axch -o cmd:15,%cpu --sort=-%cpu | head'
#export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
# Debian colors
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF
chown ${username}:users /home/${username}/.bashrc

# VIM CUSTOMIZATIONS
cat > /home/${username}/.vimrc << EOF
syntax on
colorscheme slate
set mouse=v
EOF
cp /home/${username}/.vimrc /root/.vimrc
chown ${username}:users /home/${username}/.vimrc

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

# PREVENT AUTO LOGIN
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
systemctl set-default graphical.target

# REMOVE ANNOYING BANNER
mv /etc/motd /etc/motd.bak

# ADD AUTHORIZED_KEYS
mkdir /root/.ssh
mkdir /home/${username}/.ssh
cp ${builddir}/authorized_keys /root/.ssh/
cp ${builddir}/authorized_keys /home/${username}/.ssh/
chown -R ${username}:users /home/${username}/.ssh
