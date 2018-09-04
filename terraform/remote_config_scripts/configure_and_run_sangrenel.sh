#!/bin/dash

SHOULD_AUTO_START_TEST=$1
KAFKA_BROKER_DNS_LIST=$2
SANGRENEL_FLAG_MESSAGE_SIZE=$3
SANGRENEL_FLAG_MESSAGE_BATCH_SIZE=$4
SANGRENEL_FLAG_NUM_WORKERS=$5

KAFKA_BROKER_PORT=9092
if [ $SHOULD_AUTO_START_TEST = "on" ]
then
  KAFKA_BROKER_LIST=$(echo $KAFKA_BROKER_DNS_LIST | sed "s/,/:$KAFKA_BROKER_PORT,/g"):$KAFKA_BROKER_PORT

  # Run sangrenel!
  sleep 30
  nohup ~/go/bin/sangrenel -topic stressed-out-topic -brokers $KAFKA_BROKER_LIST -message-size $SANGRENEL_FLAG_MESSAGE_SIZE -message-batch-size $SANGRENEL_FLAG_MESSAGE_BATCH_SIZE -workers $SANGRENEL_FLAG_NUM_WORKERS &

  echo "Running sangrenel test"
  ps aux | grep sangrenel
else
  echo "Not running sangrenel test"
fi

echo "Done with sangrenel setup"
