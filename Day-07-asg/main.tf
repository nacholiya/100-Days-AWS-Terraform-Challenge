##Creating VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }
}

##Creating IGW
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf-igw"
  }
}

##Creating Public Subnets
resource "aws_subnet" "tf_subnets" {
  for_each                = var.public_subnet
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

##Creating Route Table and Routes
resource "aws_route_table" "tf_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "tf_rt"
  }
}

##Associate the Subnets to the Route Table
resource "aws_route_table_association" "public_association" {
  for_each       = aws_subnet.tf_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.tf_rt.id
}

##AMI Data Source
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

##Creating Security Group for ASG EC2 Instance
resource "aws_security_group" "tf_asg_ec2_sg" {
  name        = "tf-asg-ec2-sg"
  description = "Security Group for ASG EC2 Instance"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allows HTTP"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-asg-ec2-sg"
  }
}

##Creating Security Gropu for ALB
resource "aws_security_group" "tf_alb_sg" {
  name        = "tf-alb-sg"
  vpc_id      = aws_vpc.tf_vpc.id
  description = "Security Group for APPlication Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-alb-sg"
  }
}

##Creating Application Load Balancer ( ALB )
resource "aws_lb" "tf_asg_alb" {
  name               = "tf-asg-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_alb_sg.id]
  subnets            = [for subnet in aws_subnet.tf_subnets : subnet.id]
  internal           = false


  tags = {
    Name = "tf-asg-alb"
  }
}

##Creating Target Group for ALB
resource "aws_lb_target_group" "tf_alb_tg" {
  name     = "tf-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf_vpc.id

  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tf-alb-tg"
  }
}

##Creating ALB Listner
resource "aws_lb_listener" "tf_alb_listner" {
  load_balancer_arn = aws_lb.tf_asg_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_alb_tg.arn
  }
}

##Creating Auto Scalling Group ( ASG )
resource "aws_autoscaling_group" "tf_asg" {
  depends_on       = [aws_lb_listener.tf_alb_listner]
  desired_capacity = 2
  min_size         = 1
  max_size         = 2

  vpc_zone_identifier = [
    for subnet in aws_subnet.tf_subnets : subnet.id
  ]

  launch_template {
    id      = aws_launch_template.tf_lt.id
    version = "$Latest"
  }

  ##Attach ASG to ALB Target Group
  target_group_arns = [
    aws_lb_target_group.tf_alb_tg.arn
  ]

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "tf-asg-instance"
    propagate_at_launch = true
  }
}
