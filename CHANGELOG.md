## [0.3.0](https://github.com/fgrehm/devstep/compare/v0.2.0...master) (unreleased)

BREAKING CHANGES:

  - Switched to the latest progrium/cedarish image which uses an unmodified Heroku
    `cedar14.sh` base stack source. More info [here](https://github.com/progrium/cedarish/commit/71e2a4af8d300c94783720d13eac79d084a35a75)

IMPROVEMENTS:

  - addons/docker: Lock installation to 1.3.0 instead of latest
  - addons/docker: Support specifying a Docker version to be installed with `DEVSTEP_DOCKER_VERSION` env var
  - buildpacks/golang: Bump default version to 1.3.3
  - buildpacks/nodejs: Bump default Node to 0.10.32
  - buildpacks/ruby: Bump default Bundler to 1.7.4
  - buildpacks/ruby: Bump default Ruby to 2.1.4

## [0.2.0](https://github.com/fgrehm/devstep/compare/v0.1.0...v0.2.0) (2014-09-24)

BREAKING CHANGES:

  - [New CLI](http://fgrehm.viewdocs.io/devstep/cli/installation) and [configuration format](http://fgrehm.viewdocs.io/devstep/cli/configuration)
  - Updated the base Docker image to latest [progrium/cedarish:cedar14](https://github.com/progrium/cedarish/tree/cedar14), reducing the image size (from `1.168GB` to `867.7MB`).

FEATURES:

  - addons/postgresql: Support for configurable data directory with `POSTGRESQL_DATA` [[GH-67]]

[GH-67]: https://github.com/fgrehm/devstep/issues/67

IMPROVEMENTS:

  - baseimage: "Shorten" `PS1` [[GH-71]]
  - buildpacks/golang: Update default installed version to 1.3.1 [[GH-72]]
  - buildpacks/ruby: Bump default Ruby to 2.1.3
  - buildpacks/ruby: Support loading rubies from `.ruby-version` [[GH-41]]
  - buildpacks/ruby: Remove dependency on RVM and make use of use Heroku's rubies [[GH-69]]

[GH-41]: https://github.com/fgrehm/devstep/issues/41
[GH-69]: https://github.com/fgrehm/devstep/issues/69
[GH-71]: https://github.com/fgrehm/devstep/issues/71
[GH-72]: https://github.com/fgrehm/devstep/issues/72

## [0.1.0](https://github.com/fgrehm/devstep/compare/v0.0.1...v0.1.0) (2014-08-22)

BREAKING CHANGES:

  - Removed support for the the `devstep-sa` image, it will be made available again if there is enough demand
  - baseimage: Updated to Ubuntu 14.04 along with latest [progrium/cedarish](https://github.com/progrium/cedarish)
  - init: Removed workaround for [docker#5510], (this will break things on Docker pre 1.0.0) [[GH-48]]
  - init: Removed support for executing `/etc/rc.local` during startup
  - buildpacks/all: Keep cached packages "namespaced" by the buildpack, which means that the cache created with Devstep 0.0.1 won't be used
  - buildpacks/php: No longer starts a PHP server by default

[docker#5510]: https://github.com/docker/docker/issues/5510
[GH-48]: https://github.com/fgrehm/devstep/issues/48

FEATURES:

  - baseimage: Added `reload-env` shortcut alias to make things easier after bootstrapping
  - baseimage: Install bash completion

IMPROVEMENTS:

  - addons/postgresql: Install 9.3
  - builder: Error out in case the root directory is specified to the builder script [[GH-57]]
  - buildpacks/php: Backport recent oficial Heroku buildpack updates
  - buildpacks/python: Backport recent oficial Heroku buildpack updates
  - buildpacks/python: Support for pip packages caching
  - buildpacks/ruby: Remove `--binary` flag when installing rubies so that any ruby can be installed.
  - buildpacks/ruby: Make use of system libraries when installing nokogiri
  - buildpacks/ruby: Use stable versions of RVM instead of latest master
  - buildpacks/ruby: Keep a cache of gems tarballs

[GH-57]: https://github.com/fgrehm/devstep/issues/57

BUG FIXES:

  - addons/docker: Make it work again [[GH-49]]
  - buildpacks/golang: Fix ownership of bind mounted dirs under `GOPATH`s during build [[GH-56]]
  - buildpacks/golang: Fix check for whether go is installed [[GH-55]]
  - buildpacks/golang: Fix `GOPATH` symlinking when the remote URL begins with a username (like `git@`) [[GH-52]]
  - buildpacks/python: Make it work with python 2.7.5 [[GH-65]]

[GH-49]: https://github.com/fgrehm/devstep/issues/49
[GH-52]: https://github.com/fgrehm/devstep/issues/52
[GH-55]: https://github.com/fgrehm/devstep/issues/55
[GH-56]: https://github.com/fgrehm/devstep/issues/56
[GH-65]: https://github.com/fgrehm/devstep/issues/65

## 0.0.1 (June 29, 2014)

First public release
