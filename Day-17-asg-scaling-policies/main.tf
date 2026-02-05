##Creating VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-17-vpc"
  }
}

##Creating IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-17-igw"
  }
}

##Creating Subnet ( Public )
resource "aws_subnet" "public" {
  for_each                = var.Public_subnet
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

##Creating Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-17-public-rt"
  }
}

##Associate Route Table
resource "aws_route_table_association" "rt_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

##User Data fro AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##Creating launch Template
resource "aws_launch_template" "asg_lt" {
  name_prefix   = "Day-17-asg-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  user_data = base64encode(file("user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "day-17-asg-instance"
    }
  }
}

##Create ASG 
resource "aws_autoscaling_group" "asg" {
  name                      = "day-17-asg"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 60

  vpc_zone_identifier = [
    for subnet in aws_subnet.public : subnet.id
  ]

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "day-17-asg-instance"
    propagate_at_launch = true
  }
}

##Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "cpu_target_tracking_policy" {
  name                   = "day-17-cpu-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50

  }
}

##Step Scaling Policy
resource "aws_autoscaling_policy" "step_scaling_policy" {
  name                   = "day-17-step-scaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }
}

##Cloudwatch Alarm for Step scaling Policy
resource "aws_cloudwatch_metric_alarm" "high_cpu_step_alarm" {
  alarm_name          = "day-17-high-cpu-step-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_actions = [
    aws_autoscaling_policy.step_scaling_policy.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}