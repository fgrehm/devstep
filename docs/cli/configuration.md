# CLI Configuration
-------------------

# TODO: Update to reflect the new yaml configs

Devstep's CLI has a simple configuration mechanism in the form of Bash variables
that can be used to customize its behavior globally or for a specific project.

The available options along with its defaults are:

```sh
# Starting point for project images
DEVSTEP_SOURCE_IMAGE="fgrehm/devstep:v0.1.0"

# Root path to the project being built
DEVSTEP_WORKSPACE_PATH=`pwd`

# Name of the project being worked on
DEVSTEP_WORKSPACE_NAME=$(basename ${DEVSTEP_WORKSPACE_PATH})

# Name of Docker repository to use for the project
DEVSTEP_WORKSPACE_REPO="devstep/${DEVSTEP_WORKSPACE_NAME}"

# Host path for keeping devstep cached packages
DEVSTEP_CACHE_PATH="/tmp/devstep/cache"

# Global options for `docker run`s
DEVSTEP_RUN_OPTS=

# `devstep hack` specific options for `docker run`
DEVSTEP_HACK_RUN_OPTS=
```

During a `devstep` command run, the CLI will start by loading global config
options from `$HOME/.devsteprc` and project specific options from a `.devsteprc`
file located on the directory where the command is run.

Please note that to get project specific configs to be "merged" with global options
for `docker run`s, you need to prepend your project configs with the previously
defined value that might have been set on the global configuration file.

For example, if you want to configure a project to always link a `devstep hack`
container with a PostgreSQL database, you can add the following to your project's
`.devsteprc`:

```sh
DEVSTEP_HACK_RUN_OPTS="${DEVSTEP_HACK_RUN_OPTS} --link postgresql:db"
```

To figure out what are the configured values for a specific project, you can run
`devstep info`.

## Disabling cache

To disable the caching functionality you can set it to a blank string (`DEVSTEP_CACHE_PATH=""`)
on your `$HOME/.devsteprc`.
