# Node.js buildpack
-------------------

This buildpack is based on the [official Heroku buildpack](https://github.com/heroku/heroku-buildpack-nodejs)
and will install [Node.js](http://nodejs.org/) and configure project's dependencies
defined on a `package.json` manifest.

## How it Works

Here's an overview of what this buildpack does:

- Uses the [semver.io](https://semver.io) webservice to find the latest version of node that satisfies the [engines.node semver range](https://npmjs.org/doc/json.html#engines) in your `package.json`.
- Allows any recent version of node to be used, including [pre-release versions](https://semver.io/node.json).
- Uses an [S3 caching proxy](https://github.com/heroku/s3pository#readme) of nodejs.org for faster downloads of the node binary.
- Discourages use of dangerous semver ranges like `*` and `>0.10`.
- Uses the version of `npm` that comes bundled with `node`.
- Puts `node` and `npm` on the `PATH` so they can be executed on a hacking session.
- Always runs `npm install` to ensure [npm script hooks](https://npmjs.org/doc/misc/npm-scripts.html) are executed.

For more technical details, see the [compile script](buildpacks/nodejs/bin/compile).

## Documentation

For more information about using Node.js, please refer to the [Heroku Node.js Support](https://devcenter.heroku.com/articles/nodejs-support)
page.
