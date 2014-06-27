FROM progrium/cedarish
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

#####################################################################
# Create a default user to avoid using the container as root, we set
# the user and group ids to 1000 as it is the most common ids for
# single user Ubuntu machines.
# The provided /usr/bin/fix-permissions script can be used at startup
# to ensure the 'developer' user id / group id are the same as the
# directory bind mounted into the container.
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y sudo && \
    apt-get clean && \
    mkdir -p /.devstep/cache && \
    mkdir -p /.devstep/.profile.d && \
    mkdir -p /.devstep/bin && \
    mkdir -p /.devstep/log && \
    echo "developer:x:1000:1000:Developer,,,:/.devstep:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

#####################################################################
# Dependencies for our init script based on phusion/baseimage-docker

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python runit && \
    apt-get clean && \
    mkdir -p /etc/my_init.d && \
    mkdir -p /etc/service

#####################################################################
# * Dependencies for rubies (and possibly other programming language
#   envs as well)
# * Install and configure PostgreSQL and MySQL clients
# * Install vim because editing files with plain old vi sucks
# * Install tmux so that we can run lots of shells within the same
#   bash session (without the need of running through SSH)
# * Install `htop` because it has a nicer UI than plain old `top`
# * Download and install jq as it is being used by a few buildpacks
#   See http://stedolan.github.io/jq for more info

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y gawk libreadline6-dev libyaml-dev libgdbm-dev libncurses5-dev libffi-dev libicu-dev && \
    apt-get install -y postgresql-client mysql-client && \
    apt-get install -y software-properties-common && \
    echo "[client]\nprotocol=tcp\nuser=root" >> /.devstep/.my.cnf && \
    echo "export PGHOST=localhost" >> /.devstep/.profile.d/postgresql.sh && \
    echo "export PGUSER=postgres" >> /.devstep/.profile.d/postgresql.sh && \
    apt-get install -y --force-yes vim tmux htop bsdtar && \
    apt-get clean && \
    mkdir -p /.devstep/bin && \
    curl -L -s http://stedolan.github.io/jq/download/linux64/jq > /.devstep/bin/jq

#####################################################################
# Bring back apt .deb caching as they'll be either removed on the
# build process or cached on host machine
RUN rm /etc/apt/apt.conf.d/no-cache

#####################################################################
# Devstep goodies (ADDed at the end to increase image "cacheability")

ADD stack/bin /.devstep/bin
ADD stack/bashrc /.devstep/.bashrc
ADD stack/load-env.sh /.devstep/load-env.sh
ADD addons /.devstep/addons
ADD buildpacks /.devstep/buildpacks

#####################################################################
# Prepare buildpack dependencies
RUN for script in /.devstep/buildpacks/*/bin/install-dependencies; do \
      $script; \
    done

#####################################################################
# Fix permissions, set up init and generate locales
RUN chown -R developer:developer /.devstep && \
    chown -R developer:developer /etc/my_init.d && \
    chown -R developer:developer /etc/service && \
    chmod u+s /usr/bin/sudo && \
    ln -s /.devstep/bin/fix-fd /etc/my_init.d/02-fix-fd.sh && \
    ln -s /.devstep/bin/fix-permissions /etc/my_init.d/05-fix-permissions.sh && \
    ln -s /.devstep/bin/create-cache-symlinks /etc/my_init.d/10-create-cache-symlinks.sh && \
    ln -s /.devstep/bin/forward-linked-ports /etc/my_init.d/10-forward-linked-ports.sh && \
    chmod +x /.devstep/bin/* && \
    chmod +x /etc/my_init.d/* && \
    locale-gen en_US.UTF-8

#####################################################################
# Setup locales and default user

USER developer
ENV HOME /.devstep
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

#####################################################################
# Use our init
ENTRYPOINT ["/.devstep/bin/entrypoint"]

# Start a bash session by default
CMD ["/bin/bash", "--login"]
