#!/bin/bash

username="admin"
defaultresolution="1920 1080"
builddir="/srv/build-files"
serveoverhttp=true
removeworkspaceafterbuild=false
localtime=$(timedatectl | grep "Time zone" |awk '{print $3}')
bootmenuadditions="vga=791"
basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
release=$1
flavor=$2
workspacedir="${basedir}/workspace"
filesdir="${basedir}/${release}/${flavor}"
scriptname="${flavor}.sh"

# INSTALL DEPENDENCIES
dependencies="debootstrap arch-install-scripts live-build"
apt install -y ${dependencies}

# PREPARE BUILD-FILES
#chown -R jenkins:users ${filesdir}
if [[ ! -d ${workspacedir}/build-files ]]; then
        mkdir -p ${workspacedir}/build-files
fi
cp ${filesdir}/* ${workspacedir}/build-files/
cp ${basedir}/common/* ${workspacedir}/build-files/
echo ${username} > ${workspacedir}/build-files/username
echo ${defaultresolution} > ${workspacedir}/build-files/defaultresolution
echo ${localtime} > ${workspacedir}/build-files/localtime
echo $1 > ${workspacedir}/build-files/release

# RUN STAGES
cd ${workspacedir}
lb config --mode ubuntu -d ${release} --bootappend-live "${bootmenuadditions}"
lb bootstrap
lb chroot

# COPY BUILD FILES TO CHROOT FILESYSTEM
mkdir -p ${workspacedir}/chroot${builddir}
cp -r ${workspacedir}/build-files/* ${workspacedir}/chroot${builddir}/

# RUN SCRIPTS
#arch-chroot ${workspacedir}/work/x86_64/airootfs chmod 777 /root/${scriptname}
#arch-chroot ${workspacedir}/chroot /bin/bash -c "su - -c /root/${scriptname}"
arch-chroot ${workspacedir}/chroot /bin/bash ${builddir}/base.sh
arch-chroot ${workspacedir}/chroot /bin/bash ${builddir}/${scriptname}

# RUN BINARY
lb binary

# UBUNTU FIXES
sed -i "s/ubuntu-oneiric/ubuntu-xenial/g" ${workspacedir}/config/binary
VMLINUZ=$(ls ${workspacedir}/binary/casper |grep vmlinuz); cp ${workspacedir}/binary/casper/${VMLINUZ} ${workspacedir}/binary/casper/vmlinuz;
INITRD=$(ls ${workspacedir}/binary/casper |grep initrd); cp ${workspacedir}/binary/casper/${INITRD} ${workspacedir}/binary/casper/initrd.img; cp ${workspacedir}/binary/casper/${INITRD} ${workspacedir}/binary/casper/initrd.lz;

lb binary
# RENAME FINAL
now=$(date +"%m%d%Y")
mv ${workspacedir}/chroot/binary.hybrid.iso ${workspacedir}/ubuntu-${release}-${flavor}-${now}.iso

# SERVE OVER HTTP
if ${serveoverhttp}; then
  package="apache2"
  #if ! apt list --installed ${package} > /dev/null 2>&1; then
   # apt install -y ${package}
  #fi
  apt install ${package} -y
  mkdir -p /var/www/html/releases
  systemctl start apache2
  mv ${workspacedir}/*.iso /var/www/html/releases/
  ips=$(ip a | grep "scope" | grep -Po '(?<=inet )[\d.]+')
  echo "build available at:"
  for ip in ${ips}; do
    echo "http://${ip}/releases/ubuntu-${release}-${flavor}-${now}.iso"
  done
  # REMOVE WORKSPACE
  if ${removeworkspaceafterbuild}; then
    rm -rf ${workspacedir}
  fi
else
  echo "build available at ${workspacedir}/ubuntu-${release}-${flavor}-${now}.iso"
fi
