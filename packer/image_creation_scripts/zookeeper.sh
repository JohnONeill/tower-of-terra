#!/bin/bash

# Update package manager and get tree package
sudo apt-get update
sudo apt-get install -y tree openjdk-8-jdk

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

# Fetch necessary kafka files (for creating topic)
KAFKA_SCALA_VER=2.12
KAFKA_VER=1.1.0
KAFKA_URL=${S3_BUCKET}/kafka/kafka_$KAFKA_SCALA_VER-$KAFKA_VER.tgz
curl -sL $KAFKA_URL | gunzip | sudo tar xv -C ${REMOTE_DOWNLOAD_PATH}
