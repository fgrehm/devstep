# Inline buildpack

This is a buildpack for projects that wish to build themselves and is based on
https://github.com/kr/heroku-buildpack-inline and it expects the project to
provide the usual buildpack executables in its source tree.

If an executable file is found under `bin/compile` of the project root, this
buildpack will simply call it.
