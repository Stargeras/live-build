#!/bin/bash

workspacedir="/srv/workspace/archbuild"

# SERVE OVER HTTP
if ! pacman -Q apache > /dev/null 2>&1; then
  sudo pacman -S apache --noconfirm
fi
sudo mkdir -p /srv/http/releases
sudo systemctl restart httpd
sudo mv ${workspacedir}/*.iso /srv/http/releases/
ip a