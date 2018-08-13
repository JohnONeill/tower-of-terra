#!/bin/dash

KAFKA_CLUSTER_COUNT=$1
KAFKA_BROKER_ID=$(echo "$2+1" | bc)
ZOOKEEPER_DNS_LIST=$3
KAFKA_HOME="$4/kafka_2.12-1.1.0"

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
sudo sed -i '31d' server.properties
sudo sed -i '31i listeners=PLAINTEXT://:9092' $SERVER_PROPERTIES_PATH

cd ../bin

echo "Starting Kafka broker..."
sudo ./kafka-server-start.sh $SERVER_PROPERTIES_PATH
echo "Kafka broker is up and running!"
