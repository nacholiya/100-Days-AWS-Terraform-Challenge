 #!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "ASG Instance - Day 17" > /var/www/html/index.html