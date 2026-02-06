#!/bin/bash
set -eux

apt update -y
apt install -y nginx

systemctl start nginx
systemctl enable nginx

echo "<h1>Hello from App 1</h1>" > /var/www/html/index.html
echo "<h1>Hello from App 1</h1>" > /var/www/html/app1/index.html