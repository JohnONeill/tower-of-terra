#!/bin/dash
KAFKA_BROKER_ID=$(echo "$1+1" | bc)
ZOOKEEPER_DNS_LIST=$2
KAFKA_HOME="$3/kafka_2.12-1.1.0"
KAFKA_BROKER_DNS=$4

echo "Setting and adjusting Kafka broker configuration..."
cd $KAFKA_HOME/config
SERVER_PROPERTIES_PATH=$KAFKA_HOME/config/server.properties

# Set connection to Zookeeper instances
ZOOKEEPER_PORT=2181
ZOOKEEPER_LIST=$(echo $ZOOKEEPER_DNS_LIST | sed "s/,/:$ZOOKEEPER_PORT,/g"):$ZOOKEEPER_PORT
sudo sed -i '123d' $SERVER_PROPERTIES_PATH
sudo sed -i '123i zookeeper.connect='"$ZOOKEEPER_LIST"'' $SERVER_PROPERTIES_PATH

# Set broker id
sudo sed -i '21d' server.properties
sudo sed -i '21i broker.id='"$KAFKA_BROKER_ID"'' $SERVER_PROPERTIES_PATH

# Set listeners
echo "Setting listeners using $KAFKA_BROKER_DNS..."
sudo sed -i '31d' server.properties
sudo sed -i '31i listeners=PLAINTEXT://0.0.0.0:9092' $SERVER_PROPERTIES_PATH
sudo sed -i 's@#advertised.listeners=PLAINTEXT://your.host.name@advertised.listeners=PLAINTEXT://'"$KAFKA_BROKER_DNS"'@g' $SERVER_PROPERTIES_PATH

cd ../bin

echo "Starting Kafka broker..."
sudo sed -i '1i export JMX_PORT=${JMX_PORT:-9999}' ./kafka-server-start.sh
nohup sudo ./kafka-server-start.sh $SERVER_PROPERTIES_PATH &
ps aux | grep kafka
sleep 1
echo "Kafka broker is up and running!"
