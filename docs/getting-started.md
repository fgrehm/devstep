# Getting Started
-----------------

Devstep comes in two flavors, you can either use the provided CLI or you can build
on top of the provided images from `Dockerfile`s.

Regardless of the flavor you choose, it is a good idea to `docker pull fgrehm/devstep:v0.1.0`
before creating your first container / image for a better "user experience".
Docker will download that image as needed but by pulling it first you'll reduce
the waiting time when interacting with Devstep for the first time.

## Sanity check
---------------

This project is being developed and tested on an Ubuntu 14.04 host with Docker
1.0.0+, while it is likely to work on other distros / Docker versions /
[boot2docker](http://boot2docker.io/), I'm not sure how it will behave on the wild.

## Using the CLI
----------------

Before you try out the CLI, make sure you have Docker installed and that your
user is capable to run `docker` commands [without `sudo`](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access).

> **IMPORTANT**: The `developer` user that is used by Devstep assumes your user
and group ids are equal to `1000` when using the CLI or the container's init
process will be aborted. This is to guarantee that files created within Docker
containers have the appropriate permissions so that you can manipulate them
on the host without the need to use `sudo`. This is currently a Devstep limitation
that will be worked around in case there is enough demand or will be fixed once
Docker adds support for user namespaces ([#6600](https://github.com/dotcloud/docker/pull/6600)
/ [#6602](https://github.com/dotcloud/docker/pull/6602) / [#6603](https://github.com/dotcloud/docker/pull/6603)
/ [#4572](https://github.com/dotcloud/docker/pull/4572)).

> The `1000` id was chosen because it is the default uid / gid of Ubuntu Desktop users
that are created during the installation process. To work around this limitation,
please build your own image using the appropriate ids and add a `DEVSTEP_SOURCE_IMAGE=<YOUR-IMAGE>`
line to your `~/.devsteprc`.

To install the CLI, you can run the one liner below and read on for more:

```sh
L=$HOME/bin/devstep && curl -sL https://github.com/fgrehm/devstep/raw/v0.1.0/devstep > $L && chmod +x $L
```

_The snippet above assumes `$HOME/bin` is on your PATH, please change `$HOME/bin`
to an appropriate path in case your system is not configured like that._

### `devstep hack`

This is the easiest way to get started with Devstep. By running the command
from your project's root, Devstep will:

1. Create a Docker container based on `fgrehm/devstep` with project sources bind
   mounted at `/workspace`.
2. Detect and install project's dependencies on the new container using the
   available buildpacks.
3. Start a `bash` session with everything in place for you to do your work.

Once you `exit` the `bash` session, the container will be garbage collected
(aka `docker rm`ed).

In case you need to provide additional parameters to the underlying `docker run`
command you can use the `-r` flag. For example, `devstep hack -r "-p 80:8080"` will
redirect the `8080` port on your host to the port `80` within the container.

### `devstep build`

By running the command from your project's root, Devstep will:

1. Create a Docker container based on `fgrehm/devstep` with project sources bind
   mounted at `/workspace`.
2. Detect and install project's dependencies on the new container using the
   available buildpacks.
3. `docker commit` the container to a `devstep/<PROJECT>:<TIMESTAMP>` image.
4. `docker tag` the new image as `devstep/<PROJECT>:latest`.

The `devstep/<PROJECT>` images act like snapshots of your project dependencies
and will be used as the source image for subsequent `devstep` commands instead
of the `fgrehm/devstep` image.

For example, running a `devstep hack` after building the image will use `devstep/<PROJECT>:latest`
as the base container for new "hacking sessions" so that you don't have to build
your project's environment from scratch. The same applies for a new `devstep build`,
which will build on top of the latest image reducing the overall build time when
compared to reconfiguring the environment from scratch using
`Dockerfile`s.

Because the `build` command bind mounts your project sources on the Docker container
during the configuration process, you'll have to provide the full path to sources
on the host machine as a Docker volume in order to work on the project.
`devstep hack` can take care of that for you or you can manually:

```sh
docker run -ti -v `pwd`:/workspace devstep/<PROJECT>
```

### Bootstrapping a new project (AKA solving the chicken or the egg problem)

Assuming you are willing to use Docker / Devstep to avoid cluttering your machine
with development tools, there's no point on installing Ruby / Python / ... on your
computer in order to scaffold a new project. To make that process easier, you can
use the `devstep bootstrap` command.

That command will start an interactive `bash` session with the current directory
bind mounted as `/workspace` on the container and you'll be able to manually
install packages / tools required to scaffold your new project. You can even
force a specific buildpack to run from there.

For example, scaffolding a new Rails project means:

```sh
cd $HOME/projects # or whatever directory you keep your projects
devstep bootstrap -w my_app

build-project -b ruby
reload-env
gem install rails
rails new my_app

exit # Or do some extra setup before exiting
```

Once you `exit` the container, you should end up with a `devstep/my_app` image
and a brand new Rails app under `$HOME/projects/my_app` on your machine. To
abort the bootstrap process, just `exit 1` from within the container and answer
'No' when asked for confirmation for commiting the image.

As with `devstep build`, subsequent `devstep` commands like `build` and `hack`
will use `devstep/my_app:latest` as the source image. Project sources
also won't get stored inside the Docker image and you'll need to provide the
full path to its sources on the host machine as a Docker volume in order to
work on the project. `devstep hack` can take care of that for you or you can
manually:

```sh
docker run -ti -v `pwd`:/workspace devstep/<PROJECT>
```

To bootstrap projects for other platforms and frameworks you can follow a similar
approach, replacing the Ruby / Rails specifics with the platform / framework
of choice.

### Caching project's dependencies packages on the host

As mentioned on the [introduction](introduction) section, Devstep is also capable
of reducing disk space and initial configuration times by caching packages on the
host using a strategy similar to [vagrant-cachier's cache buckets](http://fgrehm.viewdocs.io/vagrant-cachier/how-does-it-work).
This behavior is enabled by default and will be further documented on the future.
For now you need to know that the `/tmp/devstep/cache` dir on the host will be bind
mounted to containers created by the CLI under `/.devstep/cache` and most of your
project's dependencies packages will be downloaded to there. Note that the dependencies
themselves are extracted and kept inside the images built by the CLI and you can
safely clean things up or disable the caching behavior at will.

To disable the caching functionality you can add the `DEVSTEP_CACHE_PATH=""`
line to your `~/.devsteprc`.

### Other commands

* `clean` -> Remove all images built for the current project
* `pristine` -> Rebuild current project associated Docker image from scratch
* `run` -> Run a one off command against the current source image
* `images` -> Display images available for the current project
* `ps` -> List all containers associated with the current project
* `info` -> Show some information about the current project

For the most up-to-date list of supported commands, run `devstep --help`.


## Building images using `Dockerfiles`
--------------------------------------

In case your project require additional stuff to work you can use the provided
`fgrehm/devstep`, `fgrehm/devstep-ab` or `fgrehm/devstep-sa` images as a starting
point for your `Dockerfile`s.

The `fgrehm/devstep` image is the base image used for Devstep environments and
requires you to manually trigger the build:

```Dockerfile
FROM fgrehm/devstep:v0.1.0

# Add project to the image and build it
ADD . /workspace
WORKDIR /workspace
RUN CLEANUP=1 /.devstep/bin/build-project /workspace
```

To make things easier, there's also a `fgrehm/devstep-ab:v0.1.0` image that
does the same steps as outlined above automatically for you by leveraging `ONBUILD`
instructions, trimming down your `Dockerfile` to a single line:

```Dockerfile
FROM fgrehm/devstep-ab:v0.1.0
```

And in case you want to run extra services (like a DB) within the same container
of your project, you can use the `fgrehm/devstep-sa` image:

```Dockerfile
FROM fgrehm/devstep-sa:v0.1.0

# Add project to the image and build it
ADD . /workspace
WORKDIR /workspace
RUN CLEANUP=1 /.devstep/bin/build-project /workspace

# Configure PostgreSQL and Redis to run on the project's container
RUN /.devstep/bin/configure-addons postgresql redis
```

By using a `Dockerfile` to build your images (instead of using `devstep build`)
you'll be able to skip mounting project's sources on the container when running
it and a simple `docker run -it <IMAGE-NAME>` should do the trick. **_Keep in mind
that changes made to project sources will be kept inside the container and
you'll lose them when you `docker rm` it._**


## Available buildpacks
-----------------------

* [Bats](buildpacks/bats)
* [Go](buildpacks/golang)
* [Inline](buildpacks/inline)
* [NodeJS](buildpacks/nodejs)
* [PHP](buildpacks/php)
* [Python](buildpacks/python)
* [Ruby](buildpacks/ruby)


## More information
-------------------

If you reached this point it means you should have a good understanding of how
Devstep works and what you can do with it. If you are still wondering how you can
use the tool and / or benefit from it, please create a [new issue](https://github.com/fgrehm/devstep/issues/new)
so that we can discuss how can we improve the docs :)
