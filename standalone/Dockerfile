FROM fgrehm/devstep:base

# Use init from phusion/baseimage-docker
ENTRYPOINT ["/usr/bin/my-init"]

# Start a bash session by default
CMD ["/bin/bash"]

# Add project to the image and build it
ONBUILD ADD . /workspace
ONBUILD WORKDIR /workspace
ONBUILD RUN CLEANUP=1 /.devstep/bin/build-project /workspace
