#!/bin/bash

args=("$@")
INSTALL_TYPE=${args[0]} # e.g., zookeeper, kafka, etc

PACKER_HOME='./packer'

packer build -machine-readable ${PACKER_HOME}/image_templates/${INSTALL_TYPE}.json | tee ${PACKER_HOME}/logs/${INSTALL_TYPE}.log
