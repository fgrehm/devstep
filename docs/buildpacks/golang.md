# Go buildpack
--------------

This buildpack is based on the [Go Heroku buildpack](https://github.com/kr/heroku-buildpack-go)
and will install [Go](http://golang.org/) if a file with the `.go` extension
is found.

If a `Godep` dir is found, this buildpack will download and install [godep](https://github.com/kr/godep)
into your `$PATH` and will parse the `GoVersion` and `ImportPath` attributes
when setting things up.

Since currently devstep [does not support](https://github.com/fgrehm/devstep/issues/51)
setting the workspace directory used inside the container, this buildpack will
attempt to parse your project's import path for you using the following approach:

1. `ImportPath` from Godep configs
2. `.godir` file
3. Remote github repository URL
4. `GO_PROJECT_NAME` environmental variable

After identifying the import path, the buildpack will symlink your project sources
into the appropriate path under the `$GOPATH/src` dir.

If godep is configured, the buildpack will attempt a `godep go build` for you,
otherwise it will download project's dependencies with `go get` so you can
start hacking right away.

This buildpack will also fix `$GOPATH/src` ownership so that you can safely
mount a local checkout of a project dependency into the container without
running into permission issues.

To install a specific Go version, please use the `GO_VERSION` environmental
variable.
