#!/bin/bash

# fixes github.com/phpbrew/phpbrew/issues/433 by adding --with-icu-dir=/usr
function update_phpbrew_config() {
    local phpbrew_config="variants:
    dev:
        bcmath:
        bz2:
        calendar:
        cli:
        fpm:
        phpdbg:
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
            - --with-mysql=mysqlnd
            - --with-mysqli=mysqlnd
            - --with-pdo-mysql=mysqlnd
            - --with-mysql-sock=/var/run/mysqld/mysqld.sock
        pgsql:
        sqlite:
        ftp:
        kerberos:
        iconv:
        icu:
            - --with-icu-dir=/usr
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
"
echo "$phpbrew_config" > /opt/phpbrew/config.yaml
}

update_phpbrew_config
