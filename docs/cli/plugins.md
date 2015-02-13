# CLI Plugins
-----------

Devstep's CLI has an experimental support for plugins in the form of JavaScript
files that can be used to hook into the CLI runtime to modify its configuration
at specific points during commands execution.

Plugins should be installed to `$HOME/devstep/plugins/<PLUGIN_NAME>/plugin.js`
on the machine that is executing `devstep` commands and the only requirement is
that a plugin folder should have a `plugin.js` file.

## Plugin API

The current functionality is very rudimentary and is likely to be changed so right
now it is best explained by the [squid3-ssl proxy](https://github.com/fgrehm/devstep-squid3-ssl)
plugin source which is currently the only plugin available:

```js
// `_currentPluginPath` is the host path where the JavaScript file is located
// and is provided by Devstep's CLI plugin runtime, we keep its value on a
// separate variable because its value gets changed for each plugin that
// gets loaded.
squidRoot = _currentPluginPath;

// squidShared is the path were squid will keep both downloaded files on the host
// machine and also the generated self signed certificate so that Devstep
// containers can trust.
squidShared = squidRoot + "/shared";

// Hook into the `configLoaded` event that gets triggered right after configuration
// files are loaded (eg: `$HOME/devstep.yml` and `CURRENT_DIR/devstep.yml`)
devstep.on('configLoaded', function(config) {
  config
    // Link CLI created containers with the squid container
    .addLink('squid3:squid3.dev')
    // Share the certificate file with Devstep containers
    .addVolume(squidShared + '/certs/squid3.dev.crt:/usr/share/ca-certificates/squid3.dev.crt')
    .setEnv('HTTPS_PROXY_CERT', 'squid3.dev.crt');
    // Inject the script that will trust the squid container certificate
    .addVolume(squidRoot + '/proxy.sh:/etc/devstep/init.d/proxy.sh')

    // Sets environmental variables so that programs make use of the cache
    .setEnv('http_proxy', 'http://squid3.dev:3128')
    .setEnv('https_proxy', 'http://squid3.dev:3128')
});
```

The code above is the equivalent of passing in `-e`, `-v` and `--link` parameters
to `devstep` commands.

> The current functionality provided by the plugin runtime is pretty rudimentary
so if you have ideas for other plugins that you think would be useful, feel free to
reach out on the [CLI issue tracker](https://github.com/fgrehm/devstep-cli/issues/new)
or on [Gitter](https://gitter.im/fgrehm/devstep) so that it can be further discussed
as it will likely involve changes on the CLI itself.
