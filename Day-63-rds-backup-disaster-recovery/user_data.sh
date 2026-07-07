#!/bin/bash

# Update package list
apt-get update -y

# Install MySQL client
apt-get install -y mysql-client

# Verify installation
mysql --version > /home/ubuntu/mysql-version.txt

# Set correct ownership
chown ubuntu:ubuntu /home/ubuntu/mysql-version.txt