#!/bin/bash

set -e

if ! [ -z "${HTTPS_PROXY_CERT}" ]; then
  if ! $(grep -q "${HTTPS_PROXY_CERT}" '/etc/ca-certificates.conf'); then
    echo 'Configuring HTTPS proxy certificates'
    sudo sh -c "echo '${HTTPS_PROXY_CERT}' >> /etc/ca-certificates.conf"
    sudo /usr/sbin/update-ca-certificates &> /tmp/update-ca-certificates.log
  fi
fi

if $(which npm &>/dev/null); then
  npm config set strict-ssl false
elif ! [ -f $HOME/.npmrc ] || ! $(grep -q 'strict-ssl' $HOME/.npmrc); then
  echo 'strict-ssl = false' >> $HOME/.npmrc
fi

if ! [ -f $HOME/.bowerrc ]; then
  echo '{ "strict-ssl": false }' > $HOME/.bowerrc
fi

if ! [ -f $HOME/.pip/pip.conf ]; then
  mkdir -p $HOME/.pip
  echo -e "[global]\ncert = /etc/ssl/certs/ca-certificates.crt" > $HOME/.pip/pip.conf
fi
