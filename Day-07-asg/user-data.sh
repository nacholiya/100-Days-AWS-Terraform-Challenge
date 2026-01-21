#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Day 7 - Auto Scaling Group" > /var/www/html/index.html