# Ruby buildpack
----------------

This buildpack is based on the [Ruby Heroku buildpack](https://github.com/heroku/heroku-buildpack-ruby)
that uses [Bundler](http://bundler.io/) for dependency management. It will
install [Ruby](https://www.ruby-lang.org/en) if a `Gemfile` is found.

To specify a Ruby version, please use the [`ruby` directive](http://bundler.io/v1.6/gemfile_ruby.html)
of your project's `Gemfile`.
