# Using a custom buildpack
--------------------------

In order to use a custom buildpack you can build your own images with it, or
you can bind mount its directory with Devstep containers.

For example, you can place your buildpack sources at `$HOME/projects/my-buildpack`
and add the following line to your `$HOME/devstep.yml` so that it is available to
all Devstep environments:

```yaml
volumes:
  - '{{env "HOME"}}/projects/my-buildpack:/.devstep/buildpacks/my-buildpack'
```

If you want to use a custom base image, you can add the following line to your
project's `devstep.yml` or `$HOME/devstep.yml`:

```sh
source_image: 'my-user/an-image:a-tag'
```

For more information on creating buildpacks, please have a look at
[Heroku's documentation](https://devcenter.heroku.com/articles/buildpacks) and
[Devstep's built in buildpacks sources](https://github.com/fgrehm/devstep/tree/master/buildpacks)
for inspiration.
