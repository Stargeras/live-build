#!/bin/bash

username="admin"
defaultresolution="1920 1080"
builddir="/srv/build-files"
serveoverhttp=true
removeworkspaceafterbuild=true
localtime=$(timedatectl | grep "Time zone" |awk '{print $3}')
bootmenuadditions="live-config.nocomponents boot=live quiet splash vga=791"
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
release=$1
flavor=$2
workspacedir="${basedir}/workspace"
filesdir="${basedir}/${release}/${flavor}"
scriptname="${flavor}.sh"

# INSTALL DEPENDENCIES
dependencies="debootstrap arch-install-scripts live-build"
sudo apt install -y ${dependencies}

# PREPARE BUILD-FILES
#sudo chown -R jenkins:users ${filesdir}
if [[ ! -d ${workspacedir}/build-files ]]; then
        sudo mkdir -p ${workspacedir}/build-files
fi
sudo cp ${filesdir}/* ${workspacedir}/build-files/
sudo cp ${basedir}/common/* ${workspacedir}/build-files/
sudo echo ${username} > ${workspacedir}/build-files/username
sudo echo ${defaultresolution} > ${workspacedir}/build-files/defaultresolution
sudo echo ${localtime} > ${workspacedir}/build-files/localtime

# RUN STAGES
cd ${workspacedir}
if [[ ${release} == "bullseye"  || ${release} == "sid" ]]; then
  sudo lb config --archive-areas "main contrib non-free" -d ${release} --bootappend-live "${bootmenuadditions}" --security false
else
  sudo lb config --archive-areas "main contrib non-free" -d ${release} --bootappend-live "${bootmenuadditions}"
fi
sudo lb bootstrap
sudo lb chroot

# COPY BUILD FILES TO CHROOT FILESYSTEM
mkdir -p ${workspacedir}/chroot${builddir}
sudo cp -r ${workspacedir}/build-files/* ${workspacedir}/chroot${builddir}/

# RUN SCRIPTS
#sudo arch-chroot ${workspacedir}/work/x86_64/airootfs chmod 777 /root/${scriptname}
#sudo arch-chroot ${workspacedir}/chroot /bin/bash -c "su - -c /root/${scriptname}"
sudo arch-chroot ${workspacedir}/chroot /bin/bash ${builddir}/base.sh
sudo arch-chroot ${workspacedir}/chroot /bin/bash ${builddir}/${scriptname}

# RUN FINAL STAGE
sudo lb binary

# RENAME FINAL
now=$(date +"%m%d%Y")
sudo mv ${workspacedir}/live-image-amd64.hybrid.iso debian-${release}-${flavor}-${now}.iso

# SERVE OVER HTTP
if ${serveoverhttp}; then
  package="apache2"
  #if ! apt list --installed ${package} > /dev/null 2>&1; then
   # sudo apt install -y ${package}
  #fi
  sudo apt install apache2 -y
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
