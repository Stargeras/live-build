#!/bin/bash

workspacedir="/srv/workspace/debianbuild"
package="apache2"

# SERVE OVER HTTP
if ! apt list --installed ${package} > /dev/null 2>&1; then
  sudo apt install -y ${package}
fi
sudo mkdir -p /var/www/html/releases
sudo systemctl start apache2
sudo mv ${workspacedir}/*.iso /var/www/html/releases/
ip a