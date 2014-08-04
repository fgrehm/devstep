# CLI Installation
------------------

The CLI is a simple Bash script that you can download directly from a GitHub
tagged release, place on a directory available on your `PATH` and make it
executable.

<br>

This one liner can handle it for you assuming that `$HOME/bin` is available
on your `PATH`:

```sh
L=$HOME/bin/devstep && curl -sL https://github.com/fgrehm/devstep/raw/v0.1.0/devstep > $L && chmod +x $L
```

Please note that the CLI currently interacts with the `docker` command, so make
sure you have it installed and that your user is capable to run `docker` commands
[without `sudo`](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access).
