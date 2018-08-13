#!/bin/bash

# Update package manager and get tree package
sudo apt-get update
sudo apt-get install -y tree openjdk-8-jdk
sudo apt-get install -y bc

# Setup a download and installation directory
# NOTE: changes here should be reflected in variables to Terraform
REMOTE_DOWNLOAD_PATH=$1
mkdir ${REMOTE_DOWNLOAD_PATH}

# Fetch necessary kafka files (for creating topic)
echo "Download kafka files from Insight S3 bucket..."
S3_BUCKET=https://s3-us-west-2.amazonaws.com/insight-tech
KAFKA_SCALA_VER=2.12
KAFKA_VER=1.1.0
KAFKA_FILENAME=kafka_$KAFKA_SCALA_VER-$KAFKA_VER
KAFKA_URL=${S3_BUCKET}/kafka/${KAFKA_FILENAME}.tgz
curl -sL $KAFKA_URL | gunzip | sudo tar xv -C ${REMOTE_DOWNLOAD_PATH}

SERVER_PROPERTIES=$REMOTE_DOWNLOAD_PATH/$KAFKA_FILENAME/config/server.properties

## Set log directory
echo "Tweaking server.properties..."
sudo sed -i '60d' $SERVER_PROPERTIES
sudo sed -i '60i log.dir=/var/lib/kafka/event-log' $SERVER_PROPERTIES

## Set number of partitions
sudo sed -i '64d' $SERVER_PROPERTIES
sudo sed -i '64i num.partitions=3' $SERVER_PROPERTIES

# Set replication factor to three
sudo sed -i '74d' $SERVER_PROPERTIES
sudo sed -i '74i offsets.topic.replication.factor=2' $SERVER_PROPERTIES
