# Devstep

Devstep is a dead simple, no frills development environment builder that leverages
[Docker](https://www.docker.io/) and the [buildpack](https://devcenter.heroku.com/articles/buildpacks)
abstraction for fast and easy provisioning of project dependencies with a simple
(yet ambitious) goal in mind:

> I want to build developement environments using project's sources **only**.

In other words, I want to run a single command after a `git clone` to spin
up an environment that I can use to hack on any software project out of the box
with as close to zero configuration as possible.

Have you ever deployed an app to a platform like Heroku? How awesome it is to
`git push` some code and see it running without worrying about the infrastructure
it is going to run on? Now imagine that idea applied to any type of project,
regardless of whether they are web apps or not. This is what I'm trying to achieve
with Devstep. Be it a CLI tool, a plugin for some framework or a web app,
I don't care, I just want "someone" to do the heavy lifting of preparing an
isolated and disposable environment so that I can focus on writing and delivering
working software :-)

## Overview

Devstep is basically a Docker image builder that takes your app's source as an
input and produces a Docker image with all dependencies required for hacking on
it. There is a `devstep hack` command available on the provided CLI that starts
a bash session for some hacking but you are free to manually run the images or
use other tools to manage your containers at runtime.

The builder can be used in two different ways: as a starting point for your
`Dockerfile`s or from the provided Bash CLI.

## WIP

_Documentation is being worked on, stay tunned for updates or have a look at
project sources if you are feeling adventurous_
