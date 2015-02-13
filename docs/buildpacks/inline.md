# Inline buildpack
------------------

This is a buildpack for projects that wish to build themselves and is partially
based on https://github.com/kr/heroku-buildpack-inline

First, it checks if there is a `provision` directive on `devstep.yml` under
the project's root and it uses the instructions provided during container
provisioning.

For example:

```yaml
provision:
  - ['configure-addons', 'redis']
  - ['configure-addons', 'heroku-toolbelt']
```

Will configure the Redis and Heroku toolbelt addons.

If no `provision` instructions are found, the buildpack will look for an
executable file under `bin/compile` of the project root and will run the script
if found.
