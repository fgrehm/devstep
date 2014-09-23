# Ruby buildpack
----------------

This buildpack will install [Ruby](https://www.ruby-lang.org/en) 1.9.3+ and will
use [Bundler](http://bundler.io/) for dependency management. It will be used if
a `Gemfile` is found.

The installed Ruby will be the same one that gets installed on Heroku's Cedar 14
stack with a fallback to a Ruby from the Cedar stack.

To specify a Ruby version, please use the [`ruby` directive](http://bundler.io/v1.6/gemfile_ruby.html)
of your project's `Gemfile`, the `DEVSTEP_RUBY_VERSION` environmental variable or
from a `.ruby-version` on you project's root.
