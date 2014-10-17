#!/bin/sh

STUCCO_HOME=${1:-'/stucco'}

echo "Loading data into message queue..."

cd $STUCCO_HOME
$STUCCO_HOME/collectors/scheduler-vm.sh demo-load
