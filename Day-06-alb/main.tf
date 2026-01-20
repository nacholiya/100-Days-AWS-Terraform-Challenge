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

##creating Public Subnet 1
resource "aws_subnet" "pb_subnet_1" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "pb-subnet-1"
  }
}

##creating Public Subnet 2
resource "aws_subnet" "pb_subnet_2" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "pb-subnet-2"
  }
}

##Create Route Table and Routes
resource "aws_route_table" "tf_pb_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
}

##Associate with Subnets
resource "aws_route_table_association" "public_association" {
  for_each = {
    subnet_1 = aws_subnet.pb_subnet_1.id
    subnet_2 = aws_subnet.pb_subnet_2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.tf_pb_rt.id
}

##Creating SG for ALB
resource "aws_security_group" "tf_sg_alb" {
  name   = "tf-sg-alb"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "tf-sg-alb"
  }
}

##Creating SG for EC2
resource "aws_security_group" "tf_sg_ec2" {
  name   = "tf-sg-ec2"
  vpc_id = aws_vpc.tf_vpc.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.tf_sg_alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##creating EC2 Instance
resource "aws_instance" "tf_ec2" {
  for_each = {
    ec2_1 = aws_subnet.pb_subnet_1.id
    ec2_2 = aws_subnet.pb_subnet_2.id
  }
  ami                         = "ami-019715e0d74f695be" ##Ubuntu
  instance_type               = "t3.micro"
  subnet_id                   = each.value
  vpc_security_group_ids      = [aws_security_group.tf_sg_ec2.id]
  associate_public_ip_address = true
  user_data                   = file("user-data.sh")

  tags = {
    Name = "tf-ec2-${each.key}"
  }

}

##Creating Target Group
resource "aws_lb_target_group" "tf_tg" {
  name        = "tf-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tf_vpc.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

##Register EC2 instance with target group
resource "aws_lb_target_group_attachment" "tf_tg_attach" {
  for_each = aws_instance.tf_ec2

  target_group_arn = aws_lb_target_group.tf_tg.arn
  target_id        = each.value.id
  port             = 80
}

##Creating ALB
resource "aws_lb" "tf_alb" {
  name               = "tf-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf_sg_alb.id]
  subnets            = [aws_subnet.pb_subnet_1.id, aws_subnet.pb_subnet_2.id]

  tags = {
    Name = "tf-alb"
  }
}

##Creating ALB Listner
resource "aws_lb_listener" "tf_alb_listner" {
  depends_on = [aws_lb.tf_alb]

  load_balancer_arn = aws_lb.tf_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_tg.arn
  }
}