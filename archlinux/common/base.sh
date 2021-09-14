#!/bin/bash

packages="base-devel git bash-completion \
xorg-server xorg-apps xorg-xinit xdg-user-dirs \
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
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# CREATE ADMIN USER
useradd -m -g users -s /bin/bash -G wheel,storage,power admin

# ALLOW WHEEL SUDO
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# SET DEFAULT PWS
echo 'admin:admin' |chpasswd
echo 'root:root' | chpasswd

# CREATE HOME DIRS
su admin -c 'xdg-user-dirs-update '
su admin -c 'cp /etc/X11/xinit/xinitrc ~/.xinitrc'
su admin -c 'chmod +x ~/.xinitrc'
su admin -c  'sed -i "$ d" ~/.xinitrc'

# SET DEFAULT RESOLUTION TO 1080P (XORG)
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

# PREVENT AUTO LOGIN
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
systemctl set-default graphical.target

# REMOVE ANNOYING BANNER
mv /etc/motd /etc/motd.bak
