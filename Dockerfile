FROM progrium/cedarish
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

#####################################################################
# Create a default user to avoid using the container as root, we set
# the user and group ids to 1000 as it is the most common ids for
# single user Ubuntu machines.
# The provided /usr/bin/fix-permissions script can be used at startup
# to ensure the 'developer' user id / group id are the same as the
# directory bind mounted into the container.
RUN mkdir -p /.devstep/cache && \
    mkdir -p /.devstep/.profile.d && \
    mkdir -p /.devstep/bin && \
    mkdir -p /.devstep/log && \
    mkdir -p /workspace && \
    echo "developer:x:1000:1000:Developer,,,:/.devstep:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

#####################################################################
# Dependencies for init script based on phusion/baseimage-docker

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y runit python && \
    apt-get clean && \
    mkdir -p /etc/service && \
    mkdir -p /etc/my_init.d && \
    mkdir -p /etc/container_environment

#####################################################################
# Dependencies for rubies (and possibly other programming language
# envs as well)

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y gawk libreadline6-dev libyaml-dev libgdbm-dev libncurses5-dev libffi-dev && \
    apt-get clean

#####################################################################
# Install and configure PostgreSQL and MySQL clients
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y postgresql-client mysql-client && \
    apt-get clean

RUN echo "[client]\nprotocol=tcp\nuser=root" >> /.devstep/.my.cnf && \
    echo "export PGHOST=localhost" >> /.devstep/.profile.d/postgresql.sh && \
    echo "export PGUSER=postgres" >> /.devstep/.profile.d/postgresql.sh && \
    echo "localhost" > /etc/container_environment/PGHOST

#####################################################################
# Download and install jq as it is being used by a few buildpacks
# See http://stedolan.github.io/jq for more info
RUN mkdir -p /.devstep/bin && \
    curl -L -s http://stedolan.github.io/jq/download/linux64/jq > /.devstep/bin/jq

#####################################################################
# Download and install forego so that apps that have Procfiles can be
# easily started
RUN mkdir -p /.devstep/bin && \
    curl -L -s https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego > /.devstep/bin/forego

#####################################################################
# Because editing files with `vi` sucks, tmux allow us to run lots
# of shells within the same bash session (without the need of running
# through SSH) and `htop` has a nicer UI than plain old `top`
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --force-yes vim tmux htop

#####################################################################
# Bring back apt .deb caching as they'll be either removed on the
# build process or cached on host machine
RUN rm /etc/apt/apt.conf.d/no-cache

#####################################################################
# Devstep goodies (ADDed at the end to increase image "cacheability")

ADD stack/bin /.devstep/bin
ADD stack/bashrc /.devstep/.bashrc
ADD stack/load-env.sh /.devstep/load-env.sh
ADD buildpacks /.devstep/buildpacks
ADD addons /.devstep/addons

#####################################################################
# Fix permissions
RUN chown -R developer:developer /.devstep && \
    chown -R developer:developer /workspace && \
    chown -R developer:developer /etc/service && \
    chown -R developer:developer /etc/my_init.d && \
    chown -R developer:developer /etc/container_environment && \
    chmod +x /.devstep/bin/* && \
    chmod u+s /usr/bin/sudo && \
    echo 'source /.devstep/load-env.sh' > /etc/my_init.d/load-devstep-env.sh && \
    ln -s /.devstep/bin/fix-permissions /etc/my_init.d/fix-permissions.sh && \
    ln -s /.devstep/bin/forward-linked-ports /etc/my_init.d/forward-linked-ports.sh

USER developer
ENV HOME /.devstep
