# CLI Aliases and Binstubs

The [`commands` configurations set from `devstep.yml` files](configuration)
can be used to enable some powerful aliases in case you need to frequently
run one off commands against a previously build project image.

For example, you can keep a terminal session with a Rails server running on a
tab and on a separate tab you can keep a `devstep hack` session open for
development tasks so you can easily run tests or execute some `rake` tasks.

By specifying the following command on your `devstep.yml` you'll be able to
`devstep run server` instead of `devstep run -p 3000:3000 -- bundle exec rails server`:

```yaml
commands:
  server:
    cmd: ["bundle", "exec", "rails", "server"]
    publish: ["3000:3000"]
```

## Using binstubs

Given the configuration above, you might also want to skip the `devstep run`
part from `devstep run server` while keeping the specified configs like published
ports or volumes specified on `devstep.yml` files.

By running the `devstep binstubs` command from your project's root, a bash script
will be created under `.devstep/bin` for each specified command, so you are a `export PATH=".devstep/bin:$PATH"`
away from running just `server` using the configs outlined above.
