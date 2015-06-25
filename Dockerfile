FROM heroku/cedar:14
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

ENV HOME=/home/devstep \
    DEVSTEP_PATH=/opt/devstep \
    DEVSTEP_BIN=/opt/devstep/bin \
    DEVSTEP_CONF=/etc/devstep \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8

#####################################################################
# Copy over our build scripts
ADD image/ /tmp/build

#####################################################################
# Install required packages and do some additional setup
RUN /tmp/build/prepare.sh

#####################################################################
# Devstep goodies (ADDed at the end to increase image "cacheability")
ADD stack $DEVSTEP_PATH
RUN for script in $DEVSTEP_PATH/buildpacks/*/bin/install-dependencies; do \
      $script; \
    done

#####################################################################
# Fix permissions and set up init
RUN /tmp/build/fix-permissions.sh

#####################################################################
# Setup default user
USER developer
ENV USER developer

#####################################################################
# Use our init
ENTRYPOINT ["/opt/devstep/bin/entrypoint"]

# Start a bash session by default
CMD ["/bin/bash"]
