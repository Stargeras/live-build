#!/bin/bash

username="admin"
defaultresolution="1920 1080"
builddir="/srv/build-files"
serveoverhttp=true
removeworkspaceafterbuild=true
localtime=$(timedatectl | grep "Time zone" |awk '{print $3}')
bootmenuadditions="cow_spacesize=50% vga=791"
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
flavor=$1
workspacedir="${basedir}/workspace"
filesdir="${basedir}/${flavor}"
scriptname="${flavor}.sh"

# INSTALL ARCHISO
package="archiso"
if ! pacman -Q ${package} > /dev/null 2>&1; then
  sudo pacman -S ${package} --noconfirm
fi

# COPY BUILD-FILES
#sudo chown -R jenkins:users ${filesdir}
if [[ ! -d ${workspacedir}/build-files ]]; then
        sudo mkdir -p ${workspacedir}/build-files
fi
sudo cp ${filesdir}/* ${workspacedir}/build-files/
sudo cp ${basedir}/common/* ${workspacedir}/build-files/
sudo echo ${username} > ${workspacedir}/build-files/username
sudo echo ${defaultresolution} > ${workspacedir}/build-files/defaultresolution
sudo echo ${localtime} > ${workspacedir}/build-files/localtime

# COPY ARCHISO CONFIG
sudo cp -r /usr/share/archiso/configs/releng/* ${workspacedir}/

# ADD BOOT MENU ADDITIONS
sudo sed -i "s:archisolabel=%ARCHISO_LABEL%:archisolabel=%ARCHISO_LABEL% ${bootmenuadditions}:g" ${workspacedir}/syslinux/* ${workspacedir}/efiboot/loader/entries/*

# COPY BUILD FILES TO CHROOT FILESYSTEM
mkdir -p ${workspacedir}/airootfs${builddir}
sudo cp -r ${workspacedir}/build-files/* ${workspacedir}/airootfs${builddir}/

# INITIAL CREATE
cd ${workspacedir}
sudo mkarchiso -v .

# DELETE TO ALLOW REBUILD
sudo rm -f ${workspacedir}/work/base._prepare_airootfs_image ${workspacedir}/work/base._mkairootfs_squashfs ${workspacedir}/work/build._build_buildmode_iso ${workspacedir}/work/iso._build_iso_image
sudo rm -f ${workspacedir}/out/*

# RUN SCRIPT
sudo arch-chroot ${workspacedir}/work/x86_64/airootfs chmod a+rx ${builddir}/base.sh
sudo arch-chroot ${workspacedir}/work/x86_64/airootfs chmod a+rx ${builddir}/${scriptname}
sudo arch-chroot ${workspacedir}/work/x86_64/airootfs /bin/bash -c "${builddir}/base.sh"
sudo arch-chroot ${workspacedir}/work/x86_64/airootfs /bin/bash -c "${builddir}/${scriptname}"

# REBUILD
cd ${workspacedir}
sudo mkarchiso -v .

# RENAME FINAL
now=$(date +"%m%d%Y")
sudo mv ${workspacedir}/out/* ${workspacedir}/archlinux-${flavor}-${now}.iso

# SERVE OVER HTTP
if ${serveoverhttp}; then
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
  done
  # REMOVE WORKSPACE
  if ${removeworkspaceafterbuild}; then
    sudo rm -rf ${workspacedir}
  fi
else
  echo "build available at ${workspacedir}/archlinux-${flavor}-${now}.iso"
fi
