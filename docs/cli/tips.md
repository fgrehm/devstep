# CLI Tips and Tricks
---------------------

This is a list of tips that can make you more productive on your daily work.

## Using SSH keys inside the container

You can either configure [SSH agent forwarding](https://developer.github.com/guides/using-ssh-agent-forwarding/)
with:

```sh
DEVSTEP_HACK_RUN_OPTS="${DEVSTEP_HACK_RUN_OPTS} -v ${SSH_AUTH_SOCK}:/tmp/ssh-auth-sock -e SSH_AUTH_SOCK=/tmp/ssh-auth-sock"
```

Or you can just share you SSH keys with the container:

```sh
DEVSTEP_HACK_RUN_OPTS="${DEVSTEP_HACK_RUN_OPTS} -v ${HOME}/.ssh:/.devstep/.ssh"
```

## Making project's dependencies cache persist between host restarts

Since Devstep's cache is kept at `/tmp/devstep/cache` on the host by default,
it is likely that the OS will have it cleaned when it gets restarted. In order
to make it persistent, just set it to a folder that doesn't have that behavior
(like some dir under your `$HOME`).

For example, you can add the line below to your `$HOME/.devsteprc` to configure
the cache to be kept on `$HOME/devstep-cache`:

```sh
DEVSTEP_CACHE_PATH="$HOME/devstep-cache"
```

## Sharing RubyGems credentials with containers

If you are a RubyGem author, you will want to publish the gem to https://rubygems.org
at some point. To avoid logging in all the time when you need to do that just
share the credentials file with the containers using:

```sh
DEVSTEP_HACK_RUN_OPTS="${DEVSTEP_HACK_RUN_OPTS} -v $HOME/.gem/credentials:/.devstep/.gem/credentials"
```

## Heroku credentials with containers

If you deploy apps to Heroku, you will need to eventually use the Heroku Client
to interact with it. To avoid logging in all the time when you need to do that
just share the credentials file with the containers using:

```sh
DEVSTEP_HACK_RUN_OPTS="${DEVSTEP_HACK_RUN_OPTS} -v /home/fabio/.netrc:/.devstep/.netrc"
```
