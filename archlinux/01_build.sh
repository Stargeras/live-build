#!/bin/bash

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
filesdir="${basedir}${flavor}"
workspacedir="/srv/workspace/archbuild"
flavor=$1
scriptname="${flavor}.sh"

# COPY BUILD-FILES
#sudo chown -R jenkins:users ${filesdir}
if [[ ! -d ${workspacedir}/build-files ]]; then
        sudo mkdir -p ${workspacedir}/build-files
fi
sudo cp ${filesdir}/* ${workspacedir}/build-files/

# ARCHISO CONFIG
sudo cp -r /usr/share/archiso/configs/releng/* ${workspacedir}/
sudo sed -i "s:archisolabel=%ARCHISO_LABEL%:archisolabel=%ARCHISO_LABEL% cow_spacesize=50%:g" ${workspacedir}/syslinux/* ${workspacedir}/efiboot/loader/entries/*
sudo cp ${workspacedir}/build-files/* ${workspacedir}/airootfs/root/

# INITIAL CREATE AND DELETE TO ALLOW REBUILD
sudo mkarchiso -v ${workspacedir}/
sudo rm -f ${workspacedir}/work/base._prepare_airootfs_image ${workspacedir}/work/base._mkairootfs_squashfs ${workspacedir}/work/build._build_buildmode_iso ${workspacedir}/work/iso._build_iso_image
sudo rm -f ${workspacedir}/out/*

# RUN SCRIPT
sudo arch-chroot ${workspacedir}/work/x86_64/airootfs chmod 777 /root/${scriptname}
sudo arch-chroot ${workspacedir}/work/x86_64/airootfs /bin/bash -c "/root/${scriptname}"

# REBUILD
sudo mkarchiso -v ${workspacedir}/

# RENAME FINAL
now=$(date +"%m%d%Y")
sudo mv ${workspacedir}out/* ${workspacedir}/archlinux-${flavor}-$now.iso
