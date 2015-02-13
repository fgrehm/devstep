# Docker Addon
--------------

This addon will install Docker 1.3.0 from https://get.docker.io/builds/Linux/x86_64
and will set things up for running nested Docker containers based on https://github.com/jpetazzo/dind.

In order to use it, you need to provide both the `--privileged` flag and because
`/var/lib/docker` cannot be on AUFS, so we need to make it a volume with `-v /var/lib/docker`.

To install it you can run `configure-addons docker` from within the container.

To specify a Docker version, use the the `DEVSTEP_DOCKER_VERSION` environmental
variable.
