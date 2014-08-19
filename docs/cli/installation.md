# CLI Installation
------------------

The CLI is a simple Bash script that you can download directly from a GitHub
tagged release, place on a directory available on your `PATH` and make it
executable.

This one liner can handle it for you assuming that `$HOME/bin` is available
on your `PATH`:

```sh
L=$HOME/bin/devstep && curl -sL https://github.com/fgrehm/devstep/raw/v0.1.0/devstep > $L && chmod +x $L
```

Please note that the CLI currently interacts with the `docker` command, so make
sure you have it installed and that your user is capable to run `docker` commands
[without `sudo`](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access).

> **IMPORTANT**: A `developer` user will be used by Devstep and it assumes your
user and group ids are equal to `1000` when using the CLI or the container's init
process will be aborted. This is to guarantee that files created within Docker
containers have the appropriate permissions so that you can manipulate them
on the host without the need to use `sudo`. This is currently a Devstep limitation
that will be worked around in case there is enough demand or will be fixed once
Docker adds support for user namespaces ([#6600](https://github.com/dotcloud/docker/pull/6600)
/ [#6602](https://github.com/dotcloud/docker/pull/6602) / [#6603](https://github.com/dotcloud/docker/pull/6603)
/ [#4572](https://github.com/dotcloud/docker/pull/4572)).

> The `1000` id was chosen because it is the default uid / gid of Ubuntu Desktop users
that are created during the installation process. To work around this limitation
you can build your own image with the appropriate ids and add a `DEVSTEP_SOURCE_IMAGE=<YOUR-IMAGE>`
line to your `~/.devsteprc` so that the image is used as a source for your projects.
