#!/bin/bash
set -eux

# Update package list
apt update -y

# Install nginx
apt install -y nginx

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Replace default page
echo "<h1>Day 20 HTTPS Working</h1>" > /var/www/html/index.html

# Restart nginx to ensure changes apply
systemctl restart nginx