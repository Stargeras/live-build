#!/bin/bash

# THIS DOESN'T RUN AT INSTALL TIME. MUST RUN WHILE IN OS ENVIRONMENT

urls="https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator \
https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip"

for url in ${urls}; do
  file=$(echo ${url} | awk -F / '{print $NF}')
  wget ${url}
  echo ${file} | grep .zip >/dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    unzip ${file}
    newfile=$(echo ${file} | awk -F _ '{print $1}')
    chmod +x ${newfile}
    mv ${newfile} /usr/local/bin/
    rm -f ${file}
  else
    chmod +x ${file}
    mv ${file} /usr/local/bin/
  fi
done
