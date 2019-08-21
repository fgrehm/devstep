# Heroku Toolbelt Addon
-----------------------

This addon will install the latest [Heroku Toolbelt](https://toolbelt.heroku.com/)
version available for the Ubuntu 14.04 release.

To install it you can run `configure-addons heroku-toolbelt` from within the container.

Keep in mind that if you run the command from the container add-on won't be available
on next `hack` run. To make the addon persistent add the following line to the
`devstep.yml` file in the project root:

```yml
provision:
  - ['configure-addons', 'heroku-toolbelt']
```
