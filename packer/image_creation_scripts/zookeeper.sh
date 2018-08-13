#!/bin/bash

# Update package manager and get tree package
sudo apt-get update
sudo apt-get install -y tree openjdk-8-jdk bc

# Setup a download and installation directory
# NOTE: changes here should be reflected in variables to Terraform
REMOTE_DOWNLOAD_PATH=$1
mkdir ${REMOTE_DOWNLOAD_PATH}

# Fetch necessary zookeeper files
echo "Download zookeeper files from Insight S3 bucket..."
S3_BUCKET=https://s3-us-west-2.amazonaws.com/insight-tech
ZOOKEEPER_VER=3.4.13
ZOOKEEPER_URL=${S3_BUCKET}/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz
curl -sL $ZOOKEEPER_URL | gunzip | sudo tar xv -C ${REMOTE_DOWNLOAD_PATH}
ZOOKEEPER_HOME="$REMOTE_DOWNLOAD_PATH/zookeeper-$ZOOKEEPER_VER"

# Fetch necessary kafka files (for creating topic)
echo "Download kafka files from Insight S3 bucket..."
KAFKA_SCALA_VER=2.12
KAFKA_VER=1.1.0
KAFKA_URL=${S3_BUCKET}/kafka/kafka_$KAFKA_SCALA_VER-$KAFKA_VER.tgz
curl -sL $KAFKA_URL | gunzip | sudo tar xv -C ${REMOTE_DOWNLOAD_PATH}

# Copy sample configuration into normal position
echo "Setting and adjusting Zookeeper configuration..."
sudo cp $ZOOKEEPER_HOME/conf/zoo_sample.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
sudo sed -i 's@/tmp/zookeeper@/var/lib/zookeeper@g' $ZOOKEEPER_HOME/conf/zoo.cfg

# Set max client count
echo "Setting max client count..."
sudo sed -i '17d' $ZOOKEEPER_HOME/conf/zoo.cfg
sudo sed -i '17i maxClientCnxns=60' $ZOOKEEPER_HOME/conf/zoo.cfg
