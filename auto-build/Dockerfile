FROM fgrehm/devstep:v0.0.1

#####################################################################
# Add project to the image and build it
ONBUILD ADD . /workspace
ONBUILD WORKDIR /workspace
ONBUILD RUN CLEANUP=1 /.devstep/bin/build-project /workspace
