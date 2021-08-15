#!/bin/bash
pacman -S pantheon firefox chromium neofetch htop gparted celluloid \
        virt-viewer freerdp --noconfirm #code npm nodejs
systemctl enable NetworkManager
systemctl enable sshd
su admin -c 'cat >> ~/.bashrc << EOF
export PS1="\[\e[31m\]\u\[\e[m\]@\h\[\e[34m\]\w\[\e[m\]\\$ "
EOF'
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

cp /root/* /home/admin/Documents/
chmod +x /home/admin/Documents/*.sh
chown -R admin:users /home/admin/
