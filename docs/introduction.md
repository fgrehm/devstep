# Introduction
--------------

Have you ever deployed an app to a platform like Heroku? How awesome it is to
`git push` some code and see it running without worrying about the infrastructure
it is going to run on? Now imagine that idea applied to any type of project,
regardless of whether they are web apps or not. This is what Devstep is all about.

At Devstep's heart, there is a self suficient [Docker image](http://docs.docker.com/introduction/understanding-docker/#docker-images)
that leverages the [buildpack](https://devcenter.heroku.com/articles/buildpacks)
abstraction for automatic detection and installation of project dependencies. The
image comes with a script that takes your app's source as an input and installs
everything that is required for hacking on it.

Be it a CLI tool, a plugin for some framework or a web app, it doesn't matter,
Devstep can do the heavy lifting of preparing an isolated and disposable
environment using as close to "zero configuration" as possible so that Developers
can **focus on writing and delivering working software**.


## Benefits

Configuring a base system from scratch to hack on a project (using Docker or not)
is not an easy task for many people. Yes, there are plenty of platform specific
images available for download on [Docker Hub](https://hub.docker.com/) but because
Devstep's base image provides an environment that is [similar to Heroku's](https://github.com/progrium/cedarish),
it should be capable of building and running a wide range of applications / tools
/ libraries from a single image without the need to worry about writing `Dockerfile`s.

With Devstep's CLI, we can also reduce the disk space and initial configuration
times by (optionally) caching packages on the host machine using a strategy similar
to [vagrant-cachier's cache buckets](http://fgrehm.viewdocs.io/vagrant-cachier/how-does-it-work),
where project dependencies packages are kept on the host while its contents are
extracted inside the container.


## Usage

Devstep can be used to build development environments in at least two different
ways: from the provided CLI or from `Dockerfile`s. To run the images built, you
can use the provided `devstep hack` command, use other tools (like [docker-compose](http://docs.docker.com/compose/))
or just `docker run` them by hand.


## What's included on the base [Docker image](https://registry.hub.docker.com/u/fgrehm/devstep/)?

That image is based on [Heroku's `cedar:14` image](https://registry.hub.docker.com/u/heroku/cedar/)
which makes up for the [Cedar-14](https://devcenter.heroku.com/articles/cedar)
stack. So everything that is available to it (and as a consequence, available to
Heroku apps) will be available for `fgrehm/devstep` environments.

On top of `heroku/cedar:14`, we:

* Create a `developer` user to avoid using `root` and creating files with wrong permissions during development.
* Install some extra devel packages (like `libreadline`) and other "nice to have"
  packages and utilities (like `vim` and `sqlite3`).
* Configure PostgreSQL and MySQL clients.
* Set the image `ENTRYPOINT` to our own init system and the default command to a `bash` login shell.
* Configure a couple of startup scripts (like automatic port forwading to linked containers).
* And add the supported buildpacks.

_For more information please have a look at the [Dockerfile](https://github.com/fgrehm/devstep/blob/master/Dockerfile)._


## Supported buildpacks

* [Golang](buildpacks/golang)
* [Inline](buildpacks/inline)
* [Node.js](buildpacks/nodejs)
* [Python](buildpacks/python)
* [Ruby](buildpacks/ruby)


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
