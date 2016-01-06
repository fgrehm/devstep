FROM heroku/cedar:14
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

ENV HOME=/home/devstep \
    DEVSTEP_PATH=/opt/devstep \
    DEVSTEP_BIN=/opt/devstep/bin \
    DEVSTEP_CONF=/etc/devstep \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8

ADD image/ /tmp/build
RUN /tmp/build/prepare.sh

ADD stack $DEVSTEP_PATH
RUN for script in $DEVSTEP_PATH/buildpacks/*/bin/install-dependencies; do $script; done \
    && /tmp/build/fix-permissions.sh

USER developer
ENV USER developer

ENTRYPOINT ["/opt/devstep/bin/entrypoint"]

CMD ["/bin/bash"]
