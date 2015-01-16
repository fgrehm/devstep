FROM progrium/cedarish:cedar14
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

ENV HOME=/home/devstep \
    DEVSTEP_PATH=/opt/devstep \
    DEVSTEP_CONF=/etc/devstep \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8

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
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p $HOME/cache && \
    mkdir -p $HOME/.profile.d && \
    mkdir -p $HOME/bin && \
    mkdir -p $HOME/log && \
    mkdir -p $DEVSTEP_PATH/bin && \
    mkdir -p $DEVSTEP_CONF/service && \
    mkdir -p $DEVSTEP_CONF/init.d && \
    echo "developer:x:1000:1000:Developer,,,:/home/devstep:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

#####################################################################
# Dependencies for our init script based on phusion/baseimage-docker

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python runit --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#####################################################################
# * Install and configure PostgreSQL and MySQL clients
# * Install bash-completion to save us a few keystrokes
# * Install vim because editing files with plain old vi sucks
# * Install `htop` because it has a nicer UI than plain old `top`
# * Install tmux so that we can run lots of shells within the same
#   bash session (without the need of running through SSH)
# * Install nodejs for Rails apps, Bazaar and Mecurial for Golang projects
#   (will be installed on demand by buildpacks on a future release)
# * Download and install jq as it is being used by a few buildpacks
#   See http://stedolan.github.io/jq for more info

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y libreadline5 libmcrypt4 libffi-dev --no-install-recommends && \
    apt-get install -y postgresql-client mysql-client libsqlite3-dev --no-install-recommends && \
    apt-get install -y --force-yes vim htop tmux mercurial bzr nodejs libssl0.9.8 --no-install-recommends && \
    apt-get install -y software-properties-common bash-completion --no-install-recommends && \
    echo "[client]\nprotocol=tcp\nuser=root" >> $HOME/.my.cnf && \
    echo "export PGHOST=localhost" >> $HOME/.profile.d/postgresql.sh && \
    echo "export PGUSER=postgres" >> $HOME/.profile.d/postgresql.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L -s http://stedolan.github.io/jq/download/linux64/jq > $DEVSTEP_PATH/bin/jq && \
    chmod +x $DEVSTEP_PATH/bin/jq

#####################################################################
# Bring back apt .deb caching as they'll be either removed on the
# build process or cached on host machine
RUN rm /etc/apt/apt.conf.d/docker-clean

#####################################################################
# Devstep buildpacks

ADD stack/buildpacks $DEVSTEP_PATH/buildpacks
RUN for script in $DEVSTEP_PATH/buildpacks/*/bin/install-dependencies; do \
      $script; \
    done

#####################################################################
# Devstep goodies (ADDed at the end to increase image "cacheability")

ADD stack /opt/devstep

#####################################################################
# Fix permissions, set up init
RUN cp $DEVSTEP_PATH/bashrc $HOME/.bashrc && \
    chown -R developer:developer $HOME && \
    chown -R developer:developer $DEVSTEP_PATH && \
    chown -R developer:developer $DEVSTEP_CONF && \
    chmod u+s /usr/bin/sudo && \
    ln -s $DEVSTEP_PATH/bin/fix-permissions $DEVSTEP_CONF/init.d/05-fix-permissions.sh && \
    ln -s $DEVSTEP_PATH/bin/create-cache-symlinks $DEVSTEP_CONF/init.d/10-create-cache-symlinks.sh && \
    ln -s $DEVSTEP_PATH/bin/forward-linked-ports $DEVSTEP_CONF/init.d/10-forward-linked-ports.sh && \
    chmod +x $DEVSTEP_PATH/bin/* && \
    chmod +x $DEVSTEP_CONF/init.d/*

#####################################################################
# Setup locales and default user

USER developer
ENV USER developer

#####################################################################
# Use our init
ENTRYPOINT ["/opt/devstep/bin/entrypoint"]

# Start a bash session by default
CMD ["/bin/bash"]
