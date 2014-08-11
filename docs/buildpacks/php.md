# PHP buildpack
---------------

This buildpack is based on the [PHP Heroku buildpack](https://github.com/heroku/heroku-buildpack-php)
and will install [PHP](https://php.net/) if a `index.php` or `composer.json` files
are found.

If a `composer.json` file is found, this buildpack will download and install [composer](https://getcomposer.org/)
into your `$PATH` unless a `composer.phar` is found alongside your project. With
composer in place, the project's dependencies will be installed and a script to
start a server for you app will also be configured.

For more information on setting things up, please read the [Heroku Docs](https://devcenter.heroku.com/categories/php)
or ask for help on [Devstep's issue tracker](https://github.com/fgrehm/devstep/issues).

Instructions for running the server (either Apache2 or NGINX) will be provided
at the end of the build process.
