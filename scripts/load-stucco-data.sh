#!/bin/sh

STUCCO_HOME=/stucco

echo "Loading data into message queue..."

cd $STUCCO_HOME
$STUCCO_HOME/collectors/replay.sh
