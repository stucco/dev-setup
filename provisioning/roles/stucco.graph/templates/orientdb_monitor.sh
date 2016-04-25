#!/bin/bash

getPID() {
    PID=`ps -ef | grep 'orientdb.www.path' | grep java | grep -v grep | awk '{print $2}'`
    if [ "x$PID" = "x" ]
    then
        PID=0
    fi
}

service orientdb start

getPID

until [ $PID -eq 0 ]; do
    sleep 10
    getPID
done
