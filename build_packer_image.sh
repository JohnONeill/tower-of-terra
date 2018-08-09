#!/bin/bash

args=("$@")
INSTALL_TYPE=${args[0]} # e.g., zookeeper, kafka, etc

PACKER_HOME='./packer'

packer build -machine-readable ${PACKER_HOME}/image_templates/packer_${INSTALL_TYPE}.json | tee ${PACKER_HOME}/logs/packer_${INSTALL_TYPE}.log
