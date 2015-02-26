#!/bin/bash

sleep 10

# number of times to retry connecting
NUM_RETRIES=10

retry_attempt=0
interval=1  # in seconds, this will double each iteration

# check for rabbitmq
while [ ${retry_attempt} -lt ${NUM_RETRIES} ]; do
  rabbitmqctl status > /dev/null 2>&1
  if [ $? -gt 0 ]; then
    echo "rabbitmq is not running yet, retying in ${interval} seconds"
    sleep ${interval}
    let "interval = interval * 2"
  else
    # if rabbitmq is running, start up the scheduler
    exec java -Xmx2G -jar {{ stucco_collector_dir }}/target/collect.jar -schedule -config {{ stucco_collector_config }} -section {{ stucco_collector_env }}
  fi
  let "retry_attempt++"
done

echo "Unable to connect to rabbitmq-server"
exit 1
