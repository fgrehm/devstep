#!/bin/bash

set -e

if ! [ -z "${HTTPS_PROXY_CERT}" ]; then
  sudo cp $HTTPS_PROXY_CERT /usr/share/ca-certificates
  sudo sh -c "echo '$(basename ${HTTPS_PROXY_CERT})' >> /etc/ca-certificates.conf"
  sudo /usr/sbin/update-ca-certificates
fi

if $(which npm &>/dev/null); then
  npm config set strict-ssl false
elif ! [ -f $HOME/.npmrc ] || ! $(grep -q 'strict-ssl' $HOME/.npmrc); then
  echo 'strict-ssl = false' >> $HOME/.npmrc
fi

if ! [ -f $HOME/.bowerrc ]; then
  echo '{ "strict-ssl": false }' > $HOME/.bowerrc
fi
