#!/bin/bash

source /etc/profile.d/phpbrew.sh

if [[ $# < 2 ]]
then
    echo "Wrong number of arguments supplied, the script needs at two arguments"
fi

phpbrew use $2
phpbrew fpm $1