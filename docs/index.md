# Devstep

Devstep is a dead simple, no frills development environment builder that is based
around a simple goal:

> I want to `git clone` and run a single command to hack on any software project.

To accomplish that, Devstep comes with a CLI that uses a "self suficient"
[Docker](https://www.docker.io/) image and the [buildpack](https://devcenter.heroku.com/articles/buildpacks)
abstraction for fast and easy provisioning of project dependencies.

## WAT?!?

Have you ever deployed an app to a platform like Heroku? How awesome it is to
`git push` some code and see it running without worrying about the infrastructure
it is going to run on? Now imagine that idea applied to any type of project,
regardless of whether they are web apps or not. This is what I'm trying to achieve
with Devstep.

Be it a CLI tool, a plugin for some framework or a web app, I don't care, I just
want "someone" to do the heavy lifting of preparing an isolated and disposable
environment using as close to "zero configuration" as possible so that I can
focus on writing and delivering working software :-)


## Why should I use it?

You can configure a Docker base image yourself using a `Dockerfile`, so why bother
using Devstep?

Because configuring a base system from scratch to hack on a project (using Docker
or not) is not an easy task for many people. Devstep's base image alleviates that
pain by providing an environment [similar to Heroku's](https://github.com/progrium/cedarish)
and should be capable of building and running a wide range of applications / tools
/ libraries (given there is a buildpack for the platform being used of course).

Devstep is also capable of reducing the disk space and initial configuration times by
(optionally) caching packages on host using a strategy similar to [vagrant-cachier's cache buckets](http://fgrehm.viewdocs.io/vagrant-cachier/how-does-it-work),
allowing you to even build images while offline.

## Ok, so how does it work?

Devstep is a Docker image builder that takes your app's source as an input and
produces a Docker image with all dependencies required for hacking on it. You
can use Devstep in two different ways (from `Dockerfile`s or from the provided
Bash CLI) and you are free to manually run the images or use other tools to manage
your containers at runtime.

For quick hacks, there is a `devstep hack` command that will create a new
container, install everything that is needed for your project and will fire up
a bash session for some hacking. Once you `exit` it, it will be garbage collected
(aka `docker rm`ed).


## What's on the [Docker image](https://index.docker.io/u/fgrehm/devstep)?

Same packages installed by [`progrium/cedarish`](https://github.com/progrium/cedarish)
(we use it as a base image) plus [some other stuff](Dockerfile), an init script
based on [`phusion/baseimage-docker`](https://github.com/phusion/baseimage-docker)'s
and [some buildpacks](https://github.com/fgrehm/devstep/tree/master/buildpacks).


## Why standard Heroku buildpacks are not used?

Because development environments have a few different needs than production
environments and not all projects are web apps. For example, PHP apps are likely
to have [opcache](http://www.php.net/manual/en/intro.opcache.php) enabled
on production to improve app's performance but have it disabled during development
and Ruby on Rails apps might require assets to be precompiled.


## Project status

This is mostly the result of many different hacks that suit my own needs and
seem to be working fine based on my [limited testing](https://github.com/fgrehm/devstep-examples).
Use at your own risk and expect things to break. Also, don't get scared by some bad code you might see
around as it will be cleaned up in case more people think this project is useful ;)


## Installing the CLI

Assuming `$HOME/bin` is on your path, you can run the one liner below to install
the [`devstep`](/devstep) script:

```sh
L=$HOME/bin/devstep && curl -sL https://github.com/fgrehm/devstep/raw/master/devstep > $L && chmod +x $L
```


## :warning: Work in progress :warning:

_Documentation is being worked on, stay tunned for updates or have a look at
project sources if you are feeling adventurous_
