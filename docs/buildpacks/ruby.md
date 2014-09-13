# Ruby buildpack
----------------

# TODO: Update as we removed the need for RVM

This buildpack will leverage [RVM](https://rvm.io) to install [Ruby](https://www.ruby-lang.org/en)
and uses [Bundler](http://bundler.io/) for dependency management. It will be
used if a `Gemfile` is found.

To specify a Ruby version, please use the [`ruby` directive](http://bundler.io/v1.6/gemfile_ruby.html)
of your project's `Gemfile` or the `RVM_RUBY_VERSION` environmental variable.

_Please note that even though RVM is used during Ruby installation, it is not
loaded by default._
