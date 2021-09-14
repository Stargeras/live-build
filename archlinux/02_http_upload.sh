#!/bin/bash

# SERVE OVER HTTP
package="apache"
if ! pacman -Q ${package} > /dev/null 2>&1; then
  sudo pacman -S ${package} --noconfirm
fi
sudo mkdir -p /srv/http/releases
sudo systemctl restart httpd
sudo mv ${workspacedir}/*.iso /srv/http/releases/
ips=$(ip a | grep "scope" | grep -Po '(?<=inet )[\d.]+')
echo "build available at:"
for ip in ${ips}; do
  echo "http://${ip}/releases/archlinux-${flavor}-${now}.iso"
fi

# Remove workspace
if ${removeworkspaceafterbuild}; then
  rm -rf ${workspacedir}
fi