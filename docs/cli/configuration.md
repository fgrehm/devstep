# CLI Configuration
-------------------

Devstep's CLI has a configuration mechanism in the form of [YAML](http://www.yaml.org/)
files that can be used to customize its behavior globally or for a specific project.

The available options are described below:

```yaml
# The Docker repository to keep images built by devstep
# DEFAULT: 'devstep/<CURRENT_DIR_NAME>'
repository: 'repo/name'

# The image used by devstep when building environments from scratch
# DEFAULT: 'fgrehm/devstep:v1.0.0'
source_image: 'source/image:tag'

# The host cache dir that gets mounted inside the container at `/home/devstep/cache`
# for speeding up the dependencies installation process.
# DEFAULT: '/tmp/devstep/cache'
cache_dir: '{{env "HOME"}}/devstep/cache'

# The directory where project sources should be mounted inside the container.
# DEFAULT: '/workspace'
working_dir: '/home/devstep/gocode/src/github.com/fgrehm/devstep-cli'

# Link to other existing containers (like a database for example).
# Please note that devstep won't start the associated containers automatically
# and an error will be raised in case the linked container does not exist or
# if it is not running.
# DEFAULT: <empty>
links:
- "postgres:db"
- "memcached:mc"

# Additional Docker volumes to share with the container.
# DEFAULT: <empty>
volumes:
- "/path/on/host:/path/on/guest"

# Environment variables.
# DEFAULT: <empty>
environment:
  RAILS_ENV: "development"

# Custom provisioning steps that can be used when the available buildpacks are not
# enough. Use it to configure addons or run additional commands during the build.
# DEFAULT: <empty>
provision:
  - ['configure-addons', 'redis']
```

During a `devstep` command run, the CLI will start by loading global config
options from `$HOME/devstep.yml` and project specific options from a `devstep.yml`
file located on the directory where the command is run and will merge them before
creating containers.

To figure out what are the configured values for a specific project after
merging settings you can run `devstep info`.
