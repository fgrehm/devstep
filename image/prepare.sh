#!/bin/bash

set -e

#####################################################################
# * Install bash-completion to save us a few keystrokes
# * Install vim because editing files with plain old vi sucks
# * Install `htop` because it has a nicer UI than plain old `top`
# * Install nodejs for Rails apps, Bazaar and Mecurial for Golang projects
#   (will be installed on demand by buildpacks on a future release)
# * Python and runit are dependencies for our init script based on
#   phusion/baseimage-docker
apt-get update
apt-get install -y --force-yes --no-install-recommends \
                sudo \
                libreadline5 \
                libmcrypt4 \
                libffi-dev \
                sqlite3 \
                libsqlite3-dev \
                vim \
                htop \
                mercurial \
                bzr \
                nodejs-legacy \
                libssl0.9.8 \
                software-properties-common \
                bash-completion \
                python \
                runit

#####################################################################
# Bring back apt .deb caching as they'll be either removed on the
# build process by devstep itself or cached on host machine
rm /etc/apt/apt.conf.d/docker-clean

#####################################################################
# Clean things up to reduce the image size
apt-get clean
apt-get autoremove
rm -rf /var/lib/apt/lists/*

#####################################################################
# Devstep environment
mkdir -p $HOME/cache
mkdir -p $HOME/.profile.d
mkdir -p $HOME/bin
mkdir -p $HOME/log
mkdir -p $DEVSTEP_PATH/bin
mkdir -p $DEVSTEP_CONF/service
mkdir -p $DEVSTEP_CONF/init.d

#####################################################################
# Create a default user to avoid using the container as root, we set
# the user and group ids to 1000 as it is the most common id for
# single user Ubuntu machines.
# The provided /usr/bin/fix-permissions script can be used at startup
# to ensure the 'developer' user id / group id are the same as the
# directory bind mounted into the container.
echo "developer:x:1000:1000:Developer,,,:/home/devstep:/bin/bash" >> /etc/passwd
echo "developer:x:1000:" >> /etc/group
echo "docker:x:999:developer" >> /etc/group
echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer
echo -e "[client]\nprotocol=tcp\nuser=root" >> $HOME/.my.cnf
echo "export PGHOST=localhost" >> $HOME/.profile.d/postgresql.sh
echo "export PGUSER=postgres" >> $HOME/.profile.d/postgresql.sh
chmod 0440 /etc/sudoers.d/developer

#####################################################################
# * Download and install jq as it is being used by a few buildpacks
#   See http://stedolan.github.io/jq for more info
curl -L -s http://stedolan.github.io/jq/download/linux64/jq > $DEVSTEP_PATH/bin/jq
chmod +x $DEVSTEP_PATH/bin/jq
