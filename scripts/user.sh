#!/bin/bash

# initiate phpbrew
export PHPBREW_HOME=/opt/phpbrew
export PHPBREW_ROOT=/opt/phpbrew
/usr/bin/phpbrew init
source $PHPBREW_ROOT/bashrc

# default phpbrew configurations
touch $PHPBREW_ROOT/config.yaml
cat <<EOF > ${PHPBREW_ROOT}/config.yaml
variants:
    dev:
        bcmath:
        bz2:
        calendar:
        cli:
        fpm:
          - --enable-fpm
          - --with-fpm-user=www-data
          - --with-fpm-group=www-data
        curl:
        ctype:
        xml:
        dom:
        filter:
        ipc:
        json:
        mbregex:
        mbstring:
        hash:
        mcrypt:
        readline:
        posix:
        pcntl:
        sockets:
        exif:
        gd:
        phar:
        pdo:
        mysql:
        pgsql:
        sqlite:
        ftp:
        kerberos:
        iconv:
        intl:
        gettext:
        session:
        zip:
        zlib:
        openssl:
        soap:
        tokenizer:
        xmlrpc:
        tidy:
extensions:
    dev:
        xhprof: latest
        xdebug: stable
EOF

# install phps
/usr/bin/phpbrew install 5.3.29 +dev
/usr/bin/phpbrew install 5.4.32 +dev
/usr/bin/phpbrew install 5.5.16 +dev
/usr/bin/phpbrew install 5.6.0 +dev

# install php extensions
phpbrew use 5.3.29
/usr/bin/phpbrew ext install +dev
phpbrew use 5.4.32
/usr/bin/phpbrew ext install +dev
phpbrew use 5.5.16
/usr/bin/phpbrew ext install +dev
phpbrew use 5.6.0
/usr/bin/phpbrew ext install +dev

# delete downloaded archives
rm /opt/phpbrew/build/*.bz2

# install php tools
phpbrew install-composer
phpbrew install-phpunit

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