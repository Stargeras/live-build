#!/bin/bash

packages="budgie-desktop gnome firefox chromium neofetch htop gparted \
        virt-viewer cups networkmanager-openvpn network-manager-applet transmission-gtk rhythmbox \
        celluloid noto-fonts papirus-icon-theme breeze freerdp"
aurpackages="f5vpn cackey plata-theme"

pacman -S ${packages} --noconfirm #code npm nodejs
systemctl enable NetworkManager
systemctl enable gdm
systemctl enable sshd
systemctl enable cups-browsed

su admin -c 'cat >> ~/.bashrc << EOF
export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
EOF'

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="~/Documents/build"
  su admin -c "mkdir -p ${aurdir}"
  su admin -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su admin -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su admin -c "sudo rm -rf ${aurdir}"
done

mkdir -p /home/admin/.config/autostart
cat > /home/admin/.config/autostart/script.desktop << EOF
[Desktop Entry]
Name=script
GenericName=config script
Exec=/home/admin/Documents/config.sh
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF
chmod +x /home/admin/.config/autostart/script.desktop

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

##Set Budgie as default session
cat > /var/lib/AccountsService/users/admin << EOF
[User]
Language=
XSession=budgie-desktop
EOF

cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/