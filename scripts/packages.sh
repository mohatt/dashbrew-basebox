#!/bin/bash -eux

# to ensure that the mysql root password prompt is not displayed
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# install mysql
apt-get -y install mysql-server
apt-get -y install mysql-client libmysqlclient-dev libmysqld-dev

# ensure apache is installed
apt-get -y install apache2

# configure apache and ssl
a2ensite default-ssl
make-ssl-cert generate-default-snakeoil --force-overwrite
a2enmod rewrite proxy proxy_fcgi proxy_http actions ssl mime

# changes owner of /var/www and /var/www/html
chown $PACKER_SSH_USERNAME:$PACKER_SSH_USERNAME /var/www
chown $PACKER_SSH_USERNAME:$PACKER_SSH_USERNAME /var/www/html

# install php5 build deps
apt-get -y build-dep php5

# install system php (we just want the cli sapi and the dev package)
apt-get -y install php5-dev php5-cli php-pear php5-curl
# no need for these modules
php5dismod pdo
php5dismod opcache

# install dev packages
apt-get -y install autoconf automake curl libxslt1-dev re2c libxml2 libxml2-dev bison libbz2-dev libreadline-dev
apt-get -y install libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev libjpeg8 libgd-dev libgd3 libxpm4 libc-client2007e libc-client2007e-dev
apt-get install libfcgi-dev libfcgi0ldbl libjpeg62-dbg libmcrypt-dev libssl-dev libc-client2007e libc-client2007e-dev
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
mkdir /opt/phpbrew
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
curl -L -O http://garr.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.2.9/phpMyAdmin-4.2.9-english.tar.gz
tar -xzvf phpMyAdmin-4.2.9-english.tar.gz
mv phpMyAdmin-4.2.9-english /opt/pma
rm phpMyAdmin-4.2.9-english.tar.gz
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

# copy monit init.d file
cp /tmp/config-files/etc/init.d/monit /etc/init.d/monit
chmod +x /etc/init.d/monit

# disable startup of apache2 & mysql since we're managing them through monit
update-rc.d -f apache2 remove
update-rc.d -f mysql remove

# install augeas
apt-get -y install augeas-tools