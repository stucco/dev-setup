Installs [Stucco](http://stucco.github.io/). Usage:

    roles:
    - { role: ornl-sava.stucco, root_dir: /stucco }

See `defaults/main.yml` file for list of all options.

Requires:
  * Java/maven
  * Nodejs/npm
  * etcd