# Getting Started
-----------------

Devstep comes in two flavors, you can either use the provided CLI or you can build
on top of the provided images from `Dockerfile`s.

Regardless of the flavor you choose, it is a good idea to `docker pull fgrehm/devstep:v1.0.0`
before creating your first container / image for a better user experience. Docker
will download that image as needed when using `Dockerfile`s but the Devstep CLI won't.

## Sanity check
---------------

This project is being developed and tested on an Ubuntu 14.04 host with Docker
1.9.0+ and on OSX using [dinghy VMs](https://github.com/codekitchen/dinghy) powered
by the [xhyve docker-machine driver](https://github.com/zchee/docker-machine-driver-xhyve).
While it is likely to work on other distros / Docker versions / boot2docker setups,
I'm not sure how it will behave on the wild.

Please note that the CLI currently defaults to connecting to a local `/var/run/docker.sock`
socket only and the user that runs `devstep` commands will need [non-root access to it](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access).
On OSX we rely on the environmental variables set by `docker-machine` (like
`DOCKER_HOST` and `DOCKER_CERT_PATH` for example) and also on the fact that the
`$HOME` dir is automagically shared with the VM that runs the docker daemon.

## Getting started with the CLI
-------------------------------

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

To install the CLI:

```sh
# On Linux (assumes `$HOME/bin` is on your `PATH`)
L=$HOME/bin/devstep && curl -sL https://github.com/fgrehm/devstep-cli/releases/download/v1.0.0/linux_amd64 > $L && chmod +x $L

# On OSX
brew tap fgrehm/devstep
brew install devstep
```

### Doing a quick hack on a project

With the CLI and Docker in place, just `cd` into your project and run `devstep hack`,
it should be all you need to start working on your project. Devstep will create
a Docker container, will install your project dependencies in it and at the end
you'll be dropped on a `bash` session inside the container with project sources
available at `/workspace`. **Don't forget to `eval $(docker-machine env <vm-name>)` /
`eval $(dinghy env)` in case you are on OSX.**

From inside the container, you can do your work as you would on your own machine.
For example, you can use `rake test` to run your Ruby tests or `go build` to
compile Golang apps while editing files from your machine using your favorite IDE.

When you are done hacking, just `exit` the container and it will be "garbage
collected" (aka `docker rm`ed) and no project specific dependencies will be kept
on your machine.

### Taking snapshots of the environment to reduce startup time

Building an environment from scratch all the time you need to work on a project
is not very productive. To alleviate that pain you can use the `devstep build`
command which will create a Docker image with all dependencies required to hack
on your project so that further `devstep hack`s have a reduced startup time.

When your project dependencies are changed (like when a new RubyGem is needed
for a Ruby app), you can run `devstep build` again and it will reuse the previously
built image as a starting point for building the new environment instead of
starting from scratch, so use it for projects that you hack on every day.

### Accessing web apps from the host machine

The `devstep hack` command accepts an additional `-p` parameter that accepts ports
in the same way that the [Docker CLI](https://docs.docker.com/reference/commandline/cli/#run)
does. For example, if your app runs on the `8080` port, you can start your hacking
sessions with:

```sh
devstep hack -p 8080:8080
```

And it will redirect the `8080` port on your host to the `8080` port within the
container so you can just hit `http://localhost:8080` (or `http://DOCKER_HOST:8080`)
on your browser to see your app running after it is up.

### Using databases or other services from within containers

In order to connect your project to additional services you can either [link containers](http://docs.docker.com/userguide/dockerlinks/#container-linking)
to the appropriate service if you want to manage it from outside or install and
configure it by hand inside the container.

Connecting to services that runs from other containers are as simple as passing
in a `--link` argument to the `devstep hack` command. The provided base image is
smart enough to detect that a link has been provided and will automatically forward
a `localhost` port to the external service published port.

For example, you can start a PostgreSQL service on the background with:

```sh
docker run -d --name postgres postgres:9.3
```

And then start your hacking session with:

```sh
devstep hack --link postgres:db
```

From inside the container you'll be able to access the external PostgreSQL service
using the local `5432` port that is redirected to the same port [exposed](http://docs.docker.com/reference/builder/#expose)
by that image.

Installing services inside the container makes sense if, for example, you are
developing a library that interacts with it. Please note that since the Docker
image does not run Ubuntu's default init process (it uses [runit](http://smarden.org/runit/)
instead), some additional steps will be required to start the service. Recipes
for installing some services are available in the form of "addons" so you don't
have to worry about that.

For example, installing and configuring [memcached](http://memcached.org/) inside
the container is a matter of running `configure-addons memcached` from there.

### Bootstrapping a new project (AKA solving the chicken or the egg problem)

Assuming you are willing to use Docker / Devstep to avoid cluttering your machine
with development tools, there's no point on installing Ruby / Python / ... on your
computer in order to scaffold a new project. To make that process easier, you can
use the `devstep bootstrap` command and manually trigger a buildpack build from
there using the `build-project` command.

For example, scaffolding a new Rails project means:

```sh
cd $HOME/projects # or whatever directory you keep your projects
devstep bootstrap -r devstep/my_app

build-project -b ruby
reload-env
gem install rails
rails new my_app

exit # Or do some extra setup before exiting
```

Once you `exit` the container, you will end up with a `devstep/my_app` image
and a brand new Rails app under `$HOME/projects/my_app` on the host machine.

To bootstrap projects for other platforms and frameworks you can follow a similar
approach, replacing the Ruby / Rails specifics with the platform / framework
of choice.

As with `devstep build`, subsequent `devstep` commands like `build` and `hack`
will use `devstep/my_app:latest` as the source image so that the environment
don't have to be rebuilt from scratch.

### Caching project's dependencies packages on the host

As mentioned on the [introduction](introduction) section, Devstep is also capable
of reducing disk space and initial configuration times by caching packages on the
host using a strategy similar to [vagrant-cachier's cache buckets](http://fgrehm.viewdocs.io/vagrant-cachier/how-does-it-work).

This behavior is enabled by default and will be further documented on the future.
For now you need to know that the `/tmp/devstep/cache` dir on the host will be bind
mounted to containers created by the CLI under `/home/devstep/cache` and most of your
project's dependencies packages will be downloaded there. Note that the dependencies
themselves are extracted and kept inside the images built by the CLI and you can
safely clean things up or disable the caching behavior at will.

## Building images using `Dockerfile`s
--------------------------------------

In case your project require additional dependencies to work you can use the provided
`fgrehm/devstep` image as a starting point for your `Dockerfile`s.

The `fgrehm/devstep` image is the base image used for Devstep environments and
requires you to manually trigger the build:

```Dockerfile
FROM fgrehm/devstep:v1.0.0

# Add project to the image and build it
ADD . /workspace
WORKDIR /workspace
RUN CLEANUP=1 /opt/devstep/bin/build-project /workspace
```

By using a `Dockerfile` to build your images (instead of using `devstep build`)
you'll be able to skip mounting project's sources on the container when running
it and a simple `docker run -it <IMAGE-NAME>` should do the trick. **_Keep in mind
that changes made to project sources will be kept inside the container and
you'll lose them when you `docker rm` it._**

## More information
-------------------

If you reached this point it means you should have a good understanding of how
Devstep works and what you can do with it. For more information please check out
the links on the menu above and if you are still wondering how you can use the
tool or benefit from it, please create a [new issue](https://github.com/fgrehm/devstep/issues/new)
or reach out on [Gitter](https://gitter.im/fgrehm/devstep) so that we can have
a chat :)
