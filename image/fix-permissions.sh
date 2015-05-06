#####################################################################
# Fix permissions, set up init
cp $DEVSTEP_PATH/bashrc $HOME/.bashrc && \
chown -R developer:developer $HOME && \
chown -R developer:developer $DEVSTEP_PATH && \
chown -R developer:developer $DEVSTEP_CONF && \
chmod u+s /usr/bin/sudo && \
ln -s $DEVSTEP_PATH/bin/fix-permissions $DEVSTEP_CONF/init.d/05-fix-permissions.sh && \
ln -s $DEVSTEP_PATH/bin/create-cache-symlinks $DEVSTEP_CONF/init.d/10-create-cache-symlinks.sh && \
ln -s $DEVSTEP_PATH/bin/forward-linked-ports $DEVSTEP_CONF/init.d/10-forward-linked-ports.sh && \
chmod +x $DEVSTEP_PATH/bin/* && \
chmod +x $DEVSTEP_CONF/init.d/*
