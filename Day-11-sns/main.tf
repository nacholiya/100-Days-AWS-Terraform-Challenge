##Creating Launch Template with Cloudwatch Enabled
resource "aws_launch_template" "cloudwatch_lt" {
  name_prefix   = "cloudwatch-lt-"
  image_id      = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (Mumbai)
  instance_type = "t2.micro"

  user_data = base64encode(file("user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cloudwatch-enabled-ec2"
    }
  }
}

## Create VPC
resource "aws_vpc" "cloudwatch_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cloudwatch-vpc"
  }
}

## Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cloudwatch_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cloudwatch-public-subnet"
  }
}

## Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudwatch_vpc.id

  tags = {
    Name = "cloudwatch-igw"
  }
}

## Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudwatch_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "cloudwatch-public-rt"
  }
}

## Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

## Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "cloudwatch-ec2-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.cloudwatch_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudwatch-ec2-sg"
  }
}

## Launch EC2 instance using Launch Template
resource "aws_instance" "cloudwatch_ec2" {
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  launch_template {
    id      = aws_launch_template.cloudwatch_lt.id
    version = "$Latest"
  }

  tags = {
    Name = "cloudwatch-ec2"
  }
}


##SNS Topics for Alerts
resource "aws_sns_topic" "alerts" {
  name = "cloudwatch-alerts"
}

##E-mail Subscription for SNS Alerts
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "i.nikhil8088@gmail.com"
}

##CloudWatch CPU Utilization Alarm -> SNS
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50

  alarm_actions = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.cloudwatch_ec2.id
  }
}