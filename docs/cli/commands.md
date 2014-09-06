# CLI Commands
--------------

# TODO: Update to reflect the new yaml configs

## `devstep hack`

This is the easiest way to get started with Devstep. By running the command
from your project's root, Devstep will:

1. Create a Docker container based on `fgrehm/devstep:v0.1.0` with project
   sources bind mounted at `/workspace`.
2. Detect and install project's dependencies on the new container using the
   available buildpacks.
3. Start a `bash` session with everything in place for you to do your work.

Once you `exit` the `bash` session, the container will be garbage collected
(aka `docker rm`ed).

In case you need to provide additional parameters to the underlying `docker run`
command you can use the `-r` flag. For example, `devstep hack -r "-p 80:8080"` will
redirect the `8080` port on your host to the port `8080` within the container.

## `devstep build`

By running the command from your project's root, Devstep will:

1. Create a Docker container based on `fgrehm/devstep:v0.1.0` with project
   sources bind mounted at `/workspace`.
2. Detect and install project's dependencies on the new container using the
   available buildpacks.
3. `docker commit` the container to a `devstep/<PROJECT>:<TIMESTAMP>` image.
4. `docker tag` the new image as `devstep/<PROJECT>:latest`.

The `devstep/<PROJECT>` images act like snapshots of your project dependencies
and will be used as the source image for subsequent `devstep` commands instead
of the `fgrehm/devstep:v0.1.0` image.

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

## `devstep bootstrap`

As you might have guessed, this command can be used bootstrap new projects without
cluttering your machine with development tools just to scaffold a new project.

That command will start an interactive `bash` session with the current directory
bind mounted as `/workspace` on the container and you'll have to manually configure
the tools required to scaffold your new project. You can even force a specific
buildpack to run from there.

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


## Other commands

* `clean` -> Remove all images built for the current project
* `pristine` -> Rebuild current project associated Docker image from scratch
* `run` -> Run a one off command against the current source image
* `images` -> Display images available for the current project
* `ps` -> List all containers associated with the current project
* `info` -> Show some information about the current project

For the most up-to-date list of supported commands, run `devstep --help`.
