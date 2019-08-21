# Oracle Java Addon
-------------------

This addon will install the latest version available for the Ubuntu 14.04 release
and will leverage Devstep's caching mechanism so that the downloaded files are
reused between environments.

To install it you can run `configure-addons oracle-java-8` from within the container.

Keep in mind that if you run the command from the container add-on won't be available
on next `hack` run. To make the addon persistent add the following line to the
`devstep.yml` file in the project root:

```yml
provision:
  - ['configure-addons', 'oracle-java-8']
```
