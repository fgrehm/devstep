## [0.1.0](https://github.com/fgrehm/devstep/compare/v0.0.1...master) (unreleased)

BREAKING CHANGES:

  - baseimage: Updated to Ubuntu 14.04 along with latest [progrium/cedarish](https://github.com/progrium/cedarish)
  - init: Removed workaround for [docker/docker#5510](https://github.com/docker/docker/issues/5510)
    (this will break things on Docker pre 1.0.0) [[GH-48]]
  - init: Removed support for executing `/etc/rc.local` during startup

[GH-48]: https://github.com/fgrehm/devstep/issues/48


FEATURES:

  - baseimage: Added `reload-env` shortcut alias to make things easier after
    bootstrapping
  - baseimage: Install bash completion

IMPROVEMENTS:

  - addons/postgresql: Install 9.3
  - builder: Error out in case the root directory is specified to the builder script [[GH-57]]

[GH-57]: https://github.com/fgrehm/devstep/issues/57

BUG FIXES:

  - addons/docker: Make it work again [[GH-49]]
  - buildpacks/golang: Fix ownership of bind mounted dirs under `GOPATH`s during build [[GH-56]]
  - buildpacks/golang: Fix check for whether go is installed [[GH-55]]
  - buildpacks/golang: Fix `GOPATH` symlinking when the remote URL begins with a
    username (like `git@`) [[GH-52]]

[GH-49]: https://github.com/fgrehm/devstep/issues/49
[GH-52]: https://github.com/fgrehm/devstep/issues/52
[GH-55]: https://github.com/fgrehm/devstep/issues/55
[GH-56]: https://github.com/fgrehm/devstep/issues/56

## 0.0.1 (June 29, 2014)

First public release
