#!/bin/bash

# Install some useful things for debugging
sudo apt-get update
sudo apt-get install git vim i2c-tools -y

wget https://storage.googleapis.com/golang/go1.8.3.linux-armv6l.tar.gz
sudo tar -C /usr/local -xzf go1.8.3.linux-armv6l.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
echo "export GOPATH=/home/pi/go" >> ~/.bashrc
echo "export GOBIN=/home/pi/go/bin" >> ~/.bashrc
source ~/.bashrc