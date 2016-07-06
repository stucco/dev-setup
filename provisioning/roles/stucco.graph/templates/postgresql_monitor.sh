#!/bin/bash

getPID() {
		pgrep 'postgres'
    PID = $?
}

service postgresql start

getPID

until [ $PID -eq 0 ]; do
    sleep 10
    getPID
done