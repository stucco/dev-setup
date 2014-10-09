#!/bin/sh

STUCCO_HOME=${1:-'/stucco'}

echo "Loading data into message queue..."

cd $STUCCO_HOME
$STUCCO_HOME/collectors/replay.sh
