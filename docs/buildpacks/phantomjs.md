# PhantomJS buildpack

This buildpack will install the latest release of [PhantomJS](http://phantomjs.org)
and currently does provide automatic detection.

In order to use it, you'll need to manually invoke it with `build-project -b phantomjs`
from within your image or from a `Dockerfile`.

By default it will install the 1.9.7 version but a specific version can be installed
by specifying the `PHANTOMJS_VERSION` env var during the build. For example:
`PHANTOMJS_VERSION='1.9.6' build-project -b phantomjs` will install PhantomJS 1.9.6.
