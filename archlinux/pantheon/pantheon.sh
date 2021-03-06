#!/bin/bash
packages="pantheon lightdm-gtk-greeter epiphany chromium neofetch htop gparted celluloid \
          virt-viewer freerdp imwheel \
          inter-font ttf-opensans ttf-roboto ttf-roboto-mono ttf-droid"
aurpackages="f5vpn cackey yay switchboard-plug-pantheon-tweaks-git"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)
installappcenter="true"
disableonboarding="false"
usechromiummods="true"

pacman -S ${packages} --noconfirm
systemctl enable NetworkManager
systemctl enable sshd
systemctl enable lightdm

# Appcenter
if ${installappcenter}; then
  rm -f /etc/io.elementary.appcenter/appcenter.hiddenapps
  aurpackages+=" appcenter"
fi

# AUR Pakages
for package in ${aurpackages}; do
  aurdir="\${HOME}/Documents/aur"
  su ${username} -c "mkdir -p ${aurdir}"
  su ${username} -c "cd ${aurdir} && git clone https://aur.archlinux.org/${package}.git"
  su ${username} -c "cd ${aurdir}/${package}/ && makepkg -si --noconfirm"
  su ${username} -c "sudo rm -rf ${aurdir}"
done
# Cleanup unneeded dependencies
pacman -Rs $(pacman -Qtdq) --noconfirm

cat >> /home/${username}/.xinitrc << EOF
io.elementary.wingpanel &
plank &
exec gala
EOF

#sddm
#cp -r /usr/lib/sddm/sddm.conf.d /etc/
#sed -i "s/Current=/Current=breeze/g" /etc/sddm.conf.d/default.conf
#sed -i "s/CursorTheme=/CursorTheme=breeze_cursors/g" /etc/sddm.conf.d/default.conf

#Firefox
cat >> /usr/lib/firefox/browser/defaults/preferences/vendor.js << EOF
pref("browser.tabs.drawInTitlebar", true);
//pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

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

##Set XORG as default session
cat > /var/lib/AccountsService/users/${username} << EOF
[User]
Language=
Session=Pantheon
XSession=pantheon
EOF

# Lightdm mods
cat >> /etc/lightdm/lightdm.conf << EOF
[Seat:*]
greeter-session=lightdm-gtk-greeter
EOF
cat >> /etc/lightdm/lightdm-gtk-greeter.conf << EOF
background=/usr/share/backgrounds/elementaryos-default
EOF

# Disable first run setup dialog
if ${disableonboarding}; then
  mv /etc/xdg/autostart/io.elementary.onboarding.desktop /etc/xdg/autostart/io.elementary.onboarding.disabled
fi

# Run Chromium customizations
if ${usechromiummods}; then
  bash ${builddir}/chromium_custom.sh
fi

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/
