#!/bin/bash

builddir="/srv/build-files"
username=$(cat ${builddir}/username)

terraformversion=$(curl https://releases.hashicorp.com/terraform/ | grep href | grep -v alpha | grep -v beta | grep -v rc |sort -r | grep terraform_ | head -1 | awk -F _ '{print $NF}' | awk -F '<' '{print $1}')

urls="https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator \
https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
https://releases.hashicorp.com/terraform/${terraformversion}/terraform_${terraformversion}_linux_amd64.zip"
debs="https://az764295.vo.msecnd.net/stable/c3511e6c69bb39013c4a4b7b9566ec1ca73fc4d5/code_1.67.2-1652812855_amd64.deb \
https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb"

# INSTALL FROM URLS
for url in ${urls}; do
  file=$(echo ${url} | awk -F / '{print $NF}')
  wget ${url}
  # IF ZIP FILE
  if $(echo ${file} | grep .zip >/dev/null 2>&1); then
    unzip ${file}
    newfile=$(echo ${file} | awk -F _ '{print $1}')
    chmod +x ${newfile}
    mv ${newfile} /usr/local/bin/
    rm -f ${file}
  # IF .DEB PACKAGE
  elif $(echo ${file} | grep .deb >/dev/null 2>&1); then
    dpkg -i ${file}
    rm -f ${file}
  # ELSE STANDARD BINARY
  else
    chmod +x ${file}
    mv ${file} /usr/local/bin/
  fi
done

# INSTALL DEBS
for deb in ${debs}; do
  # NF is the number of fields (also stands for the index of the last)
  file=$(echo ${deb} | awk -F / '{print$NF}')
  wget ${deb}
  dpkg -i ${file}
  rm -f ${file}
done

# INSTALL HELM
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# INSTALL FLUXCD
curl -s https://fluxcd.io/install.sh | bash

# ADD USER TO DOCKER GROUP
usermod -aG docker ${username}
