# CLI Installation
------------------

Precompiled binaries are available for each GitHub tagged release:

```sh
# On Linux (assumes `$HOME/bin` is on your `PATH`)
L=$HOME/bin/devstep && curl -sL https://github.com/fgrehm/devstep-cli/releases/download/v1.0.0/linux_amd64 > $L && chmod +x $L

# On OSX
brew tap fgrehm/devstep
brew install devstep
```

Please note that the CLI currently defaults to connecting to a local `/var/run/docker.sock`
socket only and the user that runs `devstep` commands will need [non-root access to it](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access).
On OSX we rely on the environmental variables set by `docker-machine` (like
`DOCKER_HOST` and `DOCKER_CERT_PATH` for example) and also on the fact that the
`$HOME` dir is automagically shared with the VM that runs the docker daemon.

> **IMPORTANT**: A `developer` user will be used by Devstep and it assumes your
user and group ids are equal to `1000` when using the CLI. This is to guarantee
that files created within Docker containers have the appropriate permissions so
that you can manipulate them on the host without the need to use `sudo`. This is
currently a Devstep limitation that will be handled on a future release.

> The `1000` id was chosen because it is the default uid / gid of Ubuntu Desktop users
that are created during the installation process. To work around this limitation
you can build your own image with the appropriate ids and add a `source_image: '<YOUR-IMAGE>:<OPTIONAL-TAG>'`
line to your `~/devstep.yml` so that the image is used as a source for your projects.

> When on OSX using dinghy, this should not be a problem thanks to how it sets up
NFS shares.

## Bash autocomplete

An autocompletion script for Linux can be installed using the one liner below:

```sh
curl -sL https://github.com/codegangsta/cli/raw/master/autocomplete/bash_autocomplete | sed 's/$PROG/devstep/' | sudo tee /etc/bash_completion.d/devstep
```

On OSX it gets installed automatically thanks to Homebrew.
