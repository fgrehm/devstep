# Introduction
--------------

Have you ever deployed an app to a platform like Heroku? How awesome it is to
`git push` some code and see it running without worrying about the infrastructure
it is going to run on? Now imagine that idea applied to any type of project,
regardless of whether they are web apps or not. This is what I'm trying to achieve
with Devstep.

At Devstep's heart, there is a "self suficient" [Docker](https://www.docker.io/)
image that leverages the [buildpack](https://devcenter.heroku.com/articles/buildpacks)
abstraction for automatic detection and installation of project dependencies. The
base image comes with a script that that takes your app's source as an input and
installs everything that is required for hacking on it.

Be it a CLI tool, a plugin for some framework or a web app, it doesn't matter,
Devstep can do the heavy lifting of preparing an isolated and disposable
environment using as close to "zero configuration" as possible so that we can
focus on writing and delivering working software.


## Why should I use it?

You can configure a Docker base image yourself using a `Dockerfile`, so why bother
using Devstep?

Configuring a base system from scratch to hack on a project (using Docker or not)
is not an easy task for many people. Yes, there are plenty of platform specific
images available for download on [Docker Hub](https://hub.docker.com/) but because
Devstep's base image provides an environment that is [similar to Heroku's](https://github.com/progrium/cedarish),
it should be capable of building and running a wide range of applications / tools
/ libraries.

Devstep is also capable of reducing the disk space and initial configuration times by
(optionally) caching packages on the host machine using a strategy similar to [vagrant-cachier's cache buckets](http://fgrehm.viewdocs.io/vagrant-cachier/how-does-it-work),
allowing you to even build some images while offline.


## How can I use it?

Devstep can be used to build development environments in at least two different
ways: from `Dockerfile`s or from the provided Bash CLI. To run the images built,
you are free to `docker run` them by hand, use other tools (like [Fig](http://orchardup.github.io/fig/))
or use the provided `devstep hack` command.


## What's included on the base [Docker image](https://registry.hub.docker.com/u/fgrehm/devstep/)?

That image is based on [`progrium/cedarish`](https://github.com/progrium/cedarish),
so everything that gets installed by it will be available for `fgrehm/devstep` images.

On top of `progrium/cedarish`, we:

* Create a `developer` user to avoid using `root` and creating files with wrong permissions during development.
* Install some extra devel packages (like `libyaml-dev`) and other "nice to have"
  packages and utilities (like `vim`, `htop` and [`jq`](http://stedolan.github.io/jq/)).
* Configure PostgreSQL and MySQL clients.
* Set the image `ENTRYPOINT` to our own init system and the default command to a `bash` login shell.
* Configure a couple of startup scripts (like [automatic port forwading]() to linked containers).
* And add the supported buildpacks.

_For more information please have a look at the [Dockerfile](https://github.com/fgrehm/devstep/blob/master/Dockerfile)._


## Why standard Heroku buildpacks are not used?

Because development environments have a few different needs than production
environments and not all projects are web apps. For example, PHP apps are likely
to have [opcache](http://www.php.net/manual/en/intro.opcache.php) enabled
on production to improve app's performance but have it disabled during development
and it is a good practice to have Ruby on Rails assets precompiled on production.
But I did my best to stay as close as possible to the official buildpacks.

--------------------------------------------

That's it for a brief introduction, from here you can have a look at the [getting started](getting-started)
guide for a quick start on how to use Devstep.
