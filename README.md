# Dashbrew Base Box

A virtual machine template designed for use with [Packer](https://www.packer.io/) to build the [Dashbrew](https://github.com/mdkholy/dashbrew) basebox.

## Building

***Note:*** *You don't have to build this template in order to run [Dashbrew](https://github.com/mdkholy/dashbrew), instead you may use [the pre-built basebox](#pre-built-boxes)*.

### Software Requirements

Before building this template, you must install VirtualBox and Vagrant. Both of these software packages provide easy-to-use visual installers for all popular operating systems.

* [Packer](https://www.packer.io/downloads.html)
* [VirtualBox](https://www.virtualbox.org/)

### Clone the repository

    $ git clone https://github.com/mdkholy/dashbrew-basebox.git

### Build the Vagrant box

	$ packer build template.json

If everything went well, you should end up with a ``*.box`` file that can be used as a Vagrant basebox.

## Pre-built Boxes

The pre-build boxes are available through [Atlas (former Vagrantcloud)](https://atlas.hashicorp.com/mdkholy/boxes/dashbrew)

You can install the latest version of this box to your Vagrant installation using the following command 

    $ vagrant box add mdkholy/dashbrew

It will take a few minutes to download the box, depending on your Internet connection speed.

## Installed Components

Here are some of the components that comes pre-installed with the box.

* [Apache](http://httpd.apache.org/) 2.4
* [PHP](http://php.net/) 5.5
* [phpbrew](https://github.com/phpbrew/phpbrew)
* [MySQL](http://www.mysql.com/) 5.5
* [SQLite](http://www.sqlite.org/) 3.8
* [Python](https://www.python.org/) 2.7
* [Ruby](https://www.ruby-lang.org/) 1.9.1
* [Node.js](http://nodejs.org/) 0.10
* [PEAR](http://pear.php.net/)
* [RubyGems](https://rubygems.org/)
* [npm](https://www.npmjs.com/)
* [Git](http://git-scm.com/)
* [OpenSSL](https://www.openssl.org/)
* [MailCatcher](http://mailcatcher.me/)
* [Xdebug](http://xdebug.org/)
* [phpMyAdmin](http://www.phpmyadmin.net/) 4.3
* [Composer](https://getcomposer.org/)
* [PHPUnit](https://phpunit.de/)
* [HTTPie](https://github.com/jakubroztocil/httpie)
* [Monit](http://mmonit.com/monit/)
* [Zsh](http://www.zsh.org/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [Augeas](http://augeas.net/)
* [Vim](http://www.vim.org/)
