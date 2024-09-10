# Updating Vagrant on outdated systems

We need to use up to version 2.2.16 because of an outdated syntax in the Vagrantfile. Versions of Vagrant after that
use Ruby 3 syntax.

<https://github.com/hashicorp/vagrant/issues/12448>

```bash
wget -O vagrant.deb https://hashicorp-releases.yandexcloud.net/vagrant/2.2.16/vagrant_2.2.16_x86_64.deb
dpkg -i vagrant.deb
```
