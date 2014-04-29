FROM fgrehm/devstep:0.0.1

# Use init from phusion/baseimage-docker
ENTRYPOINT ["/.devstep/bin/my-init"]

# Add project to the image and build it
ONBUILD ADD . /workspace
ONBUILD WORKDIR /workspace
ONBUILD RUN CLEANUP=1 /.devstep/bin/devstep-build /workspace
