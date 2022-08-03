#!/bin/bash

ROOT=`cd $(dirname $0); pwd`
pid=${ROOT}/gocron.pid
log=${ROOT}/log
mkdir -p ${log}

function start() {
    echo "starting gocron web ... "
    nohup ./bin/gocron web > ${log}/gocron.log 2>&1 & echo $! > ${pid}
    echo "starting gocron-node ... "
    nohup ./bin/gocron-node > ${log}/gocron-node.log 2>&1 & echo $! >> ${pid}
}

function stop() {
    echo -n "stopping gocron... "
    cat ${pid} | xargs kill -9
    return 0
}

function restart() {
    echo -n "restarting gocron... "
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
esac