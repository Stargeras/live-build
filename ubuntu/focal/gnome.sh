#!/bin/bash

packages="ubuntu-desktop gnome-tweaks virt-viewer chromium \
syslinux-themes-ubuntu-xenial gnome-screensaver gnome-backgrounds gnome-shell-extension-dash-to-panel freerdp2-x11 imwheel"
httpdownloadurls="https://f5vpn.geneseo.edu/public/download/linux_f5vpn.x86_64.deb \
http://cackey.rkeene.org/download/0.7.5/cackey_0.7.5-1_amd64.deb"
builddir="/srv/build-files"
username=$(cat ${builddir}/username)
release=$(cat ${builddir}/release)

# Apt sources
cat > /etc/apt/sources.list << EOF
deb http://us.archive.ubuntu.com/ubuntu/ ${release} main restricted
deb http://us.archive.ubuntu.com/ubuntu/ ${release}-updates main restricted
deb http://us.archive.ubuntu.com/ubuntu/ ${release} universe
deb http://us.archive.ubuntu.com/ubuntu/ ${release}-updates universe
deb http://us.archive.ubuntu.com/ubuntu/ ${release} multiverse
deb http://us.archive.ubuntu.com/ubuntu/ ${release}-updates multiverse
deb http://us.archive.ubuntu.com/ubuntu/ ${release}-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu ${release}-security universe
deb http://security.ubuntu.com/ubuntu ${release}-security multiverse
EOF

apt update
apt install -y ${packages}

# Install from http links
for url in ${httpdownloadurls}; do
  # NF is the number of fields (also stands for the index of the last)
  file=$(echo ${url} | awk -F / '{print$NF}')
  wget ${url}
  dpkg -i ${file}
  rm -f ${file}
done

# fix network
cat <<EOF >/etc/NetworkManager/conf.d/allow-ethernet.conf
[keyfile]
unmanaged-devices=*,except:type:wifi,except:type:gsm,except:type:cdma,except:type:ethernet
EOF

# Prevent initial setup
echo "yes" > /home/admin/.config/gnome-initial-setup-done

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

##Firefox title bar and flex space
cat >> /etc/firefox-esr/firefox-esr.js << EOF
pref("browser.tabs.drawInTitlebar", true);
pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"urlbar-container\",\"downloads-button\",\"library-button\",\"sidebar-button\",\"fxa-toolbar-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\"],\"dirtyAreaCache\":[],\"currentVersion\":16,\"newElementCount\":2}");
EOF

# Permissions
chmod +x ${builddir}/*.sh
chown -R ${username}:users ${builddir}
chown -R ${username}:users /home/${username}/