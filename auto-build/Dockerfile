FROM fgrehm/devstep:v0.3.0

#####################################################################
# Add project to the image and build it
ONBUILD ADD . /workspace
ONBUILD WORKDIR /workspace
ONBUILD RUN CLEANUP=1 /opt/devstep/bin/build-project /workspace
