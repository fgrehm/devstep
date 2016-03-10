## [1.0.0](https://github.com/fgrehm/devstep/compare/v0.4.0...v1.0.0) (2016-03-10)

BREAKING CHANGES:

  - baseimage: Removed tmux
  - addons: Removed `docker`
  - buildpacks: Removed `bats` and `phantomjs`

IMPROVEMENTS:

  - buildpacks/golang: Bump default Go to 1.6
  - buildpacks/golang: Pass in `-t` to `go get` [[GH-96]]
  - buildpacks/inline: Support strings for the `provision` config on `devstep.yml` files
  - buildpacks/inline: Always run inline `provision` commands at the end of the build process, after all of the other buildpacks have kicked in.
  - buildpacks/python: Bump default Python to 2.7.11

BUG FIXES:

  - buildpacks/golang: Nicely handle blanky `git remote`s [[GH-94]]
  - buildpacks/inline: Improve `devstep.yml` `provision` config handling [[GH-97]]
  - buildpacks/inline: Return the same exit code returned by the `provision` command [[GH-99]]

[GH-94]: https://github.com/fgrehm/devstep/issues/94
[GH-96]: https://github.com/fgrehm/devstep/issues/96
[GH-97]: https://github.com/fgrehm/devstep/issues/97
[GH-99]: https://github.com/fgrehm/devstep/issues/99

## [0.4.0](https://github.com/fgrehm/devstep/compare/v0.3.1...v0.4.0) (2015-07-06)

BREAKING CHANGES:

  - Switched to `heroku/cedar:14` [image](https://registry.hub.docker.com/u/heroku/cedar/)
    since it [has been brought up to speed](https://github.com/heroku/stack-images/pull/15)
    with `progrium/cedarish`.
  - Autobuild image support has been removed [[GH-93]]

[GH-93]: https://github.com/fgrehm/devstep/issues/93

IMPROVEMENTS:

  - buildpacks/golang: Download test dependencies by default
  - buildpacks/golang: Backport recent Golang buildpack updates
  - buildpacks/golang: Bump default Go to 1.4.2
  - buildpacks/php: Backport recent oficial Heroku buildpack updates
  - buildpacks/php: Enable support for HHVM
  - buildpacks/php: Composer's `vendor` dir is now kept inside images instead of the host machine when using the CLI
  - buildpacks/python: Backport recent oficial Heroku buildpack updates
  - buildpacks/python: Bump default Python to 2.7.10
  - buildpacks/nodejs: Backport recent oficial Heroku buildpack updates (including support for iojs)
  - buildpacks/nodejs: `node_modules` are now kept inside images instead of the host machine when using the CLI
  - buildpacks/ruby: Bump default Ruby to 2.2.2
  - buildpacks/ruby: Bump default Bundler to 1.10.5

## [0.3.1](https://github.com/fgrehm/devstep/compare/v0.3.0...v0.3.1) (2015-03-04)

BUG FIXES:

  - baseimage: Install `nodejs-legacy` to fix Yeoman usage [[GH-91]]
  - addons/postgres: Fix installation script [[GH-91]]

[GH-91]: https://github.com/fgrehm/devstep/pull/91
[GH-92]: https://github.com/fgrehm/devstep/pull/92

## [0.3.0](https://github.com/fgrehm/devstep/compare/v0.2.0...v0.3.0) (2015-02-12)

BREAKING CHANGES:

  - Switched to the latest `progrium/cedarish:cedar14` image which uses an unmodified
    Heroku `cedar14.sh` base stack source. More info [here](https://github.com/progrium/cedarish/tree/master/cedar14)
  - Organization of Devstep's "stack" within the Docker image got changed, please see
    commits associated with [GH-63] for more information

[GH-63]: https://github.com/fgrehm/devstep/issues/63

FEATURES:

  - [Inline buildpack now supports reading commands from `devstep.yml`](http://fgrehm.viewdocs.io/devstep/buildpacks/inline)
  - [New Oracle Java 8 addon](http://fgrehm.viewdocs.io/devstep/addons/oracle-java)
  - [New Heroku toolbelt addon](http://fgrehm.viewdocs.io/devstep/addons/heroku-toolbelt)

IMPROVEMENTS:

  - Reduced output by default and added support for `DEVSTEP_LOG` for setting the log level
  - addons/docker: Lock installation to 1.5.0 instead of latest
  - addons/docker: Support specifying a Docker version to be installed with `DEVSTEP_DOCKER_VERSION` env var
  - buildpacks/golang: Bump default version to 1.4.1
  - buildpacks/nodejs: Bump default Node to 0.10.35
  - buildpacks/php: Backport recent oficial Heroku buildpack updates
  - buildpacks/php: Download buildpack dependencies on demand
  - buildpacks/python: Backport recent oficial Heroku buildpack updates
  - buildpacks/python: Download buildpack dependencies on demand
  - buildpacks/ruby: Bump default Bundler to 1.8.0
  - buildpacks/ruby: Bump default Ruby to 2.2.0

BUG FIXES:

  - buildpacks/nodejs: Skip Node.js installation if already installed

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
