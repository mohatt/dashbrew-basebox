#!/bin/bash
 
PID_FILE=/var/run/mailcatcher.pid
NAME=mailcatcher
PROG="/usr/bin/mailcatcher"
USER=mailcatcher
GROUP=mailcatcher
 
start() {
    echo -n "Starting MailCatcher"
    if start-stop-daemon --stop --quiet --pidfile $PID_FILE --signal 0
    then
        echo " [already running]"
        exit
    fi


    for dir in /opt/phpbrew/php/*/
    do
        dir=${dir%*/}
        dirname="$(basename ${dir})"
        ini_dir=$dir/var/db
        ini_user="$(stat -c "%U" ${dir}/var)"
        ini_group="$(stat -c "%G" ${dir}/var)"
        if [ ! -d "${ini_dir}" ]; then
            mkdir $ini_dir
            chown $ini_user $ini_dir
            chgrp $ini_user $ini_dir
        fi

        ini_file=$ini_dir/mailcatcher.ini
        if [ ! -f "${ini_file}" ]; then
            touch $ini_file
            chown $ini_user $ini_file
            chgrp $ini_user $ini_file
        fi

        printf "; Mailcatcher configurations\nsendmail_path = \"/usr/bin/catchmail --smtp-ip 127.0.0.1 --smtp-port 1025 -f ${dirname}@mailcatcher.dev\"" > $ini_file
    done

    start-stop-daemon \
        --start \
        --pidfile $PID_FILE \
        --make-pidfile \
        --background \
        --exec $PROG \
        --user $USER \
        --group $GROUP \
        --chuid $USER \
        -- \
        --foreground \
        --http-ip=0.0.0.0 \
        --http-port=1080 \
        --smtp-ip=127.0.0.1 \
        --smtp-port=1025
    echo " [started]"

    return $?
}
 
stop() {
    echo -n "Stopping MailCatcher"
    start-stop-daemon \
        --stop \
        --oknodo \
        --pidfile $PID_FILE
    echo " [stopped]"
    return $?
}
 
restart() {
    stop
    start
}
 
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
        ;;
esac