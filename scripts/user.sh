#!/bin/bash

# initiate phpbrew
export PHPBREW_HOME=/opt/phpbrew
export PHPBREW_ROOT=/opt/phpbrew
/usr/bin/phpbrew init
source $PHPBREW_ROOT/bashrc

# install php tools
phpbrew install-phpunit
phpbrew install-composer

# oh my zsh
git clone -b phpbrew https://github.com/mdkholy/oh-my-zsh.git .oh-my-zsh
cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc
echo -e "${PACKER_SSH_PASSWORD}" | chsh -s /bin/zsh

# tell rubygems not to install the documentation for each package locally
echo "gem: --no-ri --no-rdoc" > .gemrc

# vagrant default ssh key
mkdir .ssh
curl -L -o .ssh/authorized_keys \
	https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
chmod -R go-rwsx .ssh