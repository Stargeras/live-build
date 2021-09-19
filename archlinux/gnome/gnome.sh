#!/bin/bash
packages="gnome firefox chromium neofetch htop gparted gnome-tweaks code ttf-droid \
        virt-viewer cups networkmanager networkmanager-openvpn transmission-gtk rhythmbox \
        celluloid gedit htop freerdp"
#packages="gnome-session gnome-tweaks gnome-terminal gnome-backgrounds gnome-calculator gnome-control-center nautilus bluez gdm pulseaudio firefox chromium neofetch htop gparted virt-viewer cups networkmanager-openvpn networkmanager transmission-gtk rhythmbox celluloid gedit htop eog freerdp"
aurpackages="f5vpn cackey gnome-shell-extension-dash-to-panel"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)
pacman -S ${packages} --noconfirm #code npm nodejs deepin-community-wallpapers
systemctl enable NetworkManager
systemctl enable gdm
systemctl enable sshd
systemctl enable cups-browsed

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="~/Documents/build"
  su ${username} -c "mkdir -p ${aurdir}"
  su ${username} -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su ${username} -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su ${username} -c "sudo rm -rf ${aurdir}"
done

# #yaru
#pacman -S ninja meson sassc --noconfirm
#su ${username} -c 'mkdir ~/Documents/build'
#su ${username} -c 'cd ~/Documents/build && git clone https://github.com/ubuntu/yaru.git'
#su ${username} -c 'cd ~/Documents/build/yaru/ && sudo ./bootstrap.sh -b'

#su ${username} -c 'cd ~/Documents/build/ && git clone https://github.com/jaxwilko/gtk-theme-framework.git'
#su ${username} -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t amarena -d /usr/share/themes/ -p /usr/share/icons/'
#su ${username} -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t palenight -d /usr/share/themes/ -p /usr/share/icons/'
#su ${username} -c 'cd ~/Documents/build/gtk-theme-framework/ && sudo ./main.sh -io -t gruvterial -d /usr/share/themes/ -p /usr/share/icons/'

# su ${username} -c 'cat >> ~/.bashrc << EOF
# export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
# EOF'

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

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

##Set XORG as default session
cat > /var/lib/AccountsService/users/${username} << EOF
[User]
Language=
XSession=gnome-xorg
EOF

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/