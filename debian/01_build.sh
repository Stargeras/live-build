#!/bin/bash

serveoverhttp=true
removeworkspaceafterbuild=true
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
release=$1
flavor=$2
workspacedir="${basedir}/workspace"
filesdir="${basedir}/${release}/${flavor}"
scriptname="${flavor}.sh"

# Install archiso
sudo apt install -y debootstrap arch-install-scripts live-build

# COPY BUILD-FILES
#sudo chown -R jenkins:users ${filesdir}
if [[ ! -d ${workspacedir}/build-files ]]; then
        sudo mkdir -p ${workspacedir}/build-files
fi
sudo cp ${filesdir}/* ${workspacedir}/build-files/
sudo cp ${basedir}/common/* ${workspacedir}/build-files/

# RUN STAGES
cd ${workspacedir}
if [[ ${release} == "bullseye"  || ${release} == "sid" ]]; then
  sudo lb config --archive-areas "main contrib non-free" -d ${release} --bootappend-live "live-config.nocomponents boot=live quiet splash" --security false
else
  sudo lb config --archive-areas "main contrib non-free" -d ${release} --bootappend-live "live-config.nocomponents boot=live quiet splash"
fi
sudo lb bootstrap
sudo lb chroot

sudo cp ${workspacedir}/build-files/* ${workspacedir}/chroot/root/

# RUN SCRIPT
#sudo arch-chroot ${workspacedir}/work/x86_64/airootfs chmod 777 /root/${scriptname}
#sudo arch-chroot ${workspacedir}/chroot /bin/bash -c "su - -c /root/${scriptname}"
sudo arch-chroot ${workspacedir}/chroot /bin/bash /root/base.sh
sudo arch-chroot ${workspacedir}/chroot /bin/bash /root/${scriptname}

# RUN FINAL STAGE
sudo lb binary

# RENAME FINAL
now=$(date +"%m%d%Y")
sudo mv ${workspacedir}/live-image-amd64.hybrid.iso debian-${release}-${flavor}-${now}.iso

# SERVE OVER HTTP
if ${serveoverhttp}; then
  package="apache2"
  if ! apt list --installed ${package} > /dev/null 2>&1; then
    sudo apt install -y ${package}
  fi
  sudo mkdir -p /var/www/html/releases
  sudo systemctl start apache2
  sudo mv ${workspacedir}/*.iso /var/www/html/releases/
  ips=$(ip a | grep "scope" | grep -Po '(?<=inet )[\d.]+')
  echo "build available at:"
  for ip in ${ips}; do
    echo "http://${ip}/releases/debian-${release}-${flavor}-${now}.iso"
  done
  # REMOVE WORKSPACE
  if ${removeworkspaceafterbuild}; then
    sudo rm -rf ${workspacedir}
  fi
else
  echo "build available at ${workspacedir}/debian-${release}-${flavor}-${now}.iso"
fi