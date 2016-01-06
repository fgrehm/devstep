# Python buildpack
------------------

This buildpack is based on the [Python Heroku buildpack](https://github.com/heroku/heroku-buildpack-python)
powered by [pip](http://www.pip-installer.org/). It will install [Python](https://www.python.org)
if a `requirements.txt` or `setup.py` files are found.

## Specify a Runtime

You can also provide arbitrary releases Python with a `runtime.txt` file.

    $ cat runtime.txt
    python-3.4.1

Runtime options include:

- python-2.7.11 (default)
- python-3.4.1
- pypy-1.9 (experimental)

Other [unsupported runtimes](https://github.com/heroku/heroku-buildpack-python/tree/master/builds/runtimes)
are available as well and are not guaranteed to play well with devstep.
