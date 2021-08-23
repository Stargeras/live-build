#!/bin/bash

workspacedir="/srv/workspace/archbuild"
package="apache"

# SERVE OVER HTTP
if ! pacman -Q ${package} > /dev/null 2>&1; then
  sudo pacman -S ${package} --noconfirm
fi
sudo mkdir -p /srv/http/releases
sudo systemctl restart httpd
sudo mv ${workspacedir}/*.iso /srv/http/releases/
ip a