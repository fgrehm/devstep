# Memcached Addon
-----------------

This addon will install the latest Memcached version available for the Ubuntu 14.04
release and it will set things up in a way that it is automatically started along
with your containers.

To install it you can run `configure-addons memcached` from within the container.

Keep in mind that if you run the command from the container add-on won't be available
on next `hack` run. To make the addon persistent add the following line to the
`devstep.yml` file in the project root:

```yml
provision:
  - ['configure-addons', 'memcached']
```
