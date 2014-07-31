## [0.1.0](https://github.com/fgrehm/devstep/compare/v0.0.1...master) (unreleased)

BREAKING CHANGES:

  - Updated to Ubuntu 14.04 along with latest [progrium/cedarish](https://github.com/progrium/cedarish)
  - Removed workaround for [docker/docker#5510](https://github.com/docker/docker/issues/5510)
    (this will break things on Docker pre 1.0.0) [[GH-48]]
  - Removed support for executing `/etc/rc.local` during startup
  - Temporarily removed support for automatically installing phantomjs for
    Rails projects that use the `poltergeist` gem (it will come back on a next
    version)

[GH-48]: https://github.com/fgrehm/devstep/issues/48


FEATURES:

  - Added `reload-env` alias to the base image to make things easier after
    bootstrapping.

IMPROVEMENTS:

  - Switch to a custom ruby buildpack based on Heroku's [[GH-58]]
  - Improved environment changes detection after builds.
  - PostgreSQL addon now installs 9.3

[GH-58]: https://github.com/fgrehm/devstep/issues/58


## 0.0.1 (June 29, 2014)

First public release
