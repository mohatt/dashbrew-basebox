#!/bin/bash -eux

# to ensure that the mysql root password prompt is not displayed
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# install mysql
apt-get -y install mysql-server
apt-get -y install mysql-client libmysqlclient-dev libmysqld-dev

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

# ensure apache is installed
apt-get -y install apache2

# install zsh
apt-get -y install zsh

# install phpbrew
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
mv phpbrew /usr/bin/phpbrew

# create phpbrew directory and allow it to by managed by a non-root user
mkdir /opt/phpbrew
chown $PACKER_SSH_USERNAME /opt/phpbrew
chgrp $PACKER_SSH_USERNAME /opt/phpbrew

# configure phpbrew paths
# source /opt/phpbrew/bashrc
touch /etc/profile.d/phpbrew.sh
cat <<EOF > /etc/profile.d/phpbrew.sh
export PHPBREW_HOME=/opt/phpbrew
export PHPBREW_ROOT=/opt/phpbrew
source /opt/phpbrew/bashrc
EOF

# force zsh to load scripts in /etc/profile and /etc/profile.d/*
cat <<EOF > /etc/zsh/zprofile
# force zsh to load scripts in /etc/profile and /etc/profile.d/*
emulate sh -c '. /etc/profile'
EOF

# install git
apt-get -y install git-core

# install ruby
apt-get -y install libyaml-dev sqlite3
curl -L -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
tar -xzvf ruby-2.1.2.tar.gz
cd ruby-2.1.2
./configure --disable-install-rdoc
make
make install
cd ..
rm -rf ruby-2.1.2.tar.gz
rm -rf ruby-2.1.2

# install nodejs
apt-get -y install nodejs

# install vim
apt-get -y install vim

# install httpie
easy_install httpie

# install supervisor
easy_install supervisor