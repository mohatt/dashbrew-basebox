#!/bin/bash -eux

# to ensure that the mysql root password prompt is not displayed
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# install mysql
apt-get -y install mysql-server
apt-get -y install mysql-client libmysqlclient-dev libmysqld-dev

# ensure apache is installed
apt-get -y install apache2
# configure apache modules
a2enmod rewrite proxy proxy_fcgi proxy_http actions ssl mime
make-ssl-cert generate-default-snakeoil --force-overwrite
# copy apache2 config file
cp /tmp/config-files/etc/apache2/apache2.conf /etc/apache2/apache2.conf
chown root:root /etc/apache2/apache2.conf
# configure default vhosts
rm -rf /var/www/*
rm -rf /etc/apache2/sites-enabled/*
rm -rf /etc/apache2/sites-available/*
cp /tmp/config-files/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
cp /tmp/config-files/etc/apache2/sites-available/000-default-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf
chown root:root /etc/apache2/sites-available/000-default.conf
chown root:root /etc/apache2/sites-available/000-default-ssl.conf
a2ensite 000-default 000-default-ssl

# install php5 build deps
apt-get -y build-dep php5

# install system php (we just want the cli sapi and the dev package)
apt-get -y install php5-dev php5-cli php5-fpm php-pear php5-curl php5-xdebug php5-mysqlnd php5-sqlite
# no need for opcache extension
php5dismod opcache
# copy default php inis (customized for development enviroment)
cp /tmp/config-files/etc/php5/fpm/php.ini /etc/php5/fpm/php.ini
cp /tmp/config-files/etc/php5/cli/php.ini /etc/php5/cli/php.ini
# copy default fpm pool config
cp /tmp/config-files/etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf
# make the directory that will contain configs for installed php-fpms
mkdir -m 0755 /etc/apache2/php
# copy php-fpms config file for system php
cp /tmp/config-files/etc/apache2/php/php-system-fpm.conf /etc/apache2/php/php-system-fpm.conf
# copy php5-fpm init.d file
cp /tmp/config-files/etc/init.d/php5-fpm /etc/init.d/php5-fpm
chmod +x /etc/init.d/php5-fpm

# install dev packages
apt-get -y install autoconf automake curl libxslt1-dev re2c libxml2 libxml2-dev bison libbz2-dev libreadline-dev
apt-get -y install libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev libjpeg8 libgd-dev libgd3 libxpm4 libc-client2007e libc-client2007e-dev
apt-get -y install libfcgi-dev libfcgi0ldbl libjpeg62-dbg libmcrypt-dev libssl-dev libc-client2007e libc-client2007e-dev
apt-get -y install libssl-dev openssl
apt-get -y install gettext libgettextpo-dev libgettextpo0
apt-get -y install libicu48 libicu-dev
apt-get -y install libmhash-dev libmhash2
apt-get -y install libmcrypt-dev libmcrypt4

# workaround for configure error: freetype.h not found
ln -s /usr/include/freetype2 /usr/include/freetype2/freetype

# install zsh
apt-get -y install zsh

# install phpbrew
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
mv phpbrew /usr/bin/phpbrew
chmod +x /usr/bin/phpbrew

# create phpbrew directory and allow it to by managed by a non-root user
mkdir -m 0755 /opt/phpbrew
chown $PACKER_SSH_USERNAME:$PACKER_SSH_USERNAME /opt/phpbrew

# default phpbrew configurations
cp /tmp/config-files/opt/phpbrew/config.yaml /opt/phpbrew/config.yaml
chown $PACKER_SSH_USERNAME:$PACKER_SSH_USERNAME /opt/phpbrew/config.yaml

# php-fpm control script
cp /tmp/config-files/opt/phpbrew/php-fpm.sh /opt/phpbrew/php-fpm.sh
chown $PACKER_SSH_USERNAME:$PACKER_SSH_USERNAME /opt/phpbrew/php-fpm.sh
chmod +x /opt/phpbrew/php-fpm.sh

# configure phpbrew paths
# source /opt/phpbrew/bashrc
cp /tmp/config-files/etc/profile.d/phpbrew.sh /etc/profile.d/phpbrew.sh

# force zsh to load scripts in /etc/profile and /etc/profile.d/*
cat <<EOF > /etc/zsh/zprofile
# force zsh to load scripts in /etc/profile and /etc/profile.d/*
emulate sh -c '. /etc/profile'
EOF

# install git
apt-get -y install git-core

# install ruby
apt-get -y install sqlite3
apt-get -y install ruby1.9.1 ruby1.9.1-dev
env REALLY_GEM_UPDATE_SYSTEM=1 /usr/bin/gem update --system

# install mailcatcher
/usr/bin/gem install mailcatcher --no-ri --no-rdoc

# mailcatcher config
addgroup mailcatcher
adduser --ingroup mailcatcher --disabled-password --gecos "" --no-create-home --shell "/bin/true" mailcatcher
cp /tmp/config-files/etc/init.d/mailcatcher /etc/init.d/mailcatcher
chmod +x /etc/init.d/mailcatcher

# install phpmyadmin
curl -L -O http://garr.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.2.9.1/phpMyAdmin-4.2.9.1-english.tar.gz
tar -xzvf phpMyAdmin-4.2.9.1-english.tar.gz
mv phpMyAdmin-4.2.9.1-english /opt/pma
rm phpMyAdmin-4.2.9.1-english.tar.gz
chown -R $PACKER_SSH_USERNAME:www-data /opt/pma

# copy PMA config file
cp /tmp/config-files/opt/pma/config.inc.php /opt/pma/config.inc.php
chown $PACKER_SSH_USERNAME:www-data /opt/pma/config.inc.php

# install nodejs
apt-get -y install nodejs

# install vim
apt-get -y install vim

# install httpie
easy_install httpie

# install monit
apt-get -y install monit
# copy monit config file
cp /tmp/config-files/etc/monit/monitrc /etc/monit/monitrc
# copy default monit services
cp /tmp/config-files/etc/monit/* /etc/monit/conf.d/
chown root:root /etc/monit/conf.d/*
# copy monit init.d file
cp /tmp/config-files/etc/init.d/monit /etc/init.d/monit
chmod +x /etc/init.d/monit

# disable startup of apache2 & mysql since we're managing them through monit
update-rc.d -f apache2 remove
update-rc.d -f mysql remove
update-rc.d -f php5-fpm remove
# remove php-fpm upstart service
rm /etc/init/php5-fpm.conf

# install augeas
apt-get -y install augeas-tools

# create the directory that will contain dashbrew etc files
mkdir -m 0755 /etc/dashbrew

# add symlink to dashbrew cli app
cp /tmp/config-files/usr/bin/dashbrew /usr/bin/dashbrew
chown root:root /usr/bin/dashbrew
chmod +x /usr/bin/dashbrew
