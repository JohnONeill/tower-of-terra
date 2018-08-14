#!/bin/bash

# Update package manager and get go package
sudo add-apt-repository -y ppa:gophers/archive
sudo apt-get update -y
sudo apt-get install -y golang-1.10-go

echo "Setting $GOPATH and updating $PATH..."
echo 'PATH=$PATH:/usr/lib/go-1.10/bin' >> ~/.profile
echo 'export GOPATH=$HOME/go' >> ~/.profile
echo 'PATH=$PATH:${GOPATH//://bin:}/bin' >> ~/.profile
source ~/.profile

echo "Installing sangrenel..."
go get -u github.com/jamiealquiza/sangrenel
go install github.com/jamiealquiza/sangrenel

echo "Sangrenel installed!"
