FROM fgrehm/devstep:v0.4.0

#####################################################################
# Add project to the image and build it
ONBUILD COPY . /workspace
ONBUILD WORKDIR /workspace
ONBUILD RUN CLEANUP=1 /opt/devstep/bin/build-project /workspace
