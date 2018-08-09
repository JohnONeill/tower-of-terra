#!/bin/bash

# Update package manager and get tree package
sudo apt-get update
sudo apt-get install -y tree

# Setup a download and installation directory
# NOTE: changes here should be reflected in variables to Terraform
HOME_DIR='/home/ubuntu'
DOWNLOAD_FOLDER='/downloads'
sudo mkdir ${HOME_DIR}${DOWNLOAD_FOLDER}

# Install Java Development Kit
sudo apt-get install -y openjdk-8-jdk

# Fetch necessary zookeeper files
echo "Download zookeeper files from Insight S3 bucket..."
S3_BUCKET=https://s3-us-west-2.amazonaws.com/insight-tech
ZOOKEEPER_VER=3.4.13
ZOOKEEPER_URL=${S3_BUCKET}/zookeeper/zookeeper-$ZOOKEEPER_VER.tar.gz
curl -sL $ZOOKEEPER_URL | gunzip | sudo tar xv -C ${HOME_DIR}${DOWNLOAD_FOLDER}
