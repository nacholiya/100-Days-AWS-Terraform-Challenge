##Creating VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-18-vpc"
  }
}

##Creating Public Subnets
resource "aws_subnet" "public" {
  for_each                = var.public_subnet
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.key
  }
}

##Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-18-igw"
  }
}

##Creating Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-18-public-rt"
  }
}

##Accosiate Public Route Table
resource "aws_route_table_association" "public_assoc" {
  route_table_id = aws_route_table.public_rt.id
  for_each       = aws_subnet.public
  subnet_id      = each.value.id

}

##Creating ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

  ##Inbound Rule
  #tfsec:ignore:aws-ec2-no-public-ingress-sgr Reason: ALB must be publicly accessible to serve web traffic
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ##Outbound Rule
  #tfsec:ignore:aws-ec2-no-public-egress-sgr Reason: ALB requires outbound access to communicate with targets
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "day-18-alb-sg"
  }
}

##Creating EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

  ##Inbound Rule
  ingress {
    security_groups = [aws_security_group.alb_sg.id]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
  }

  ##Outbound Rule
  egress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

##Creating Target Groups
resource "aws_lb_target_group" "tg_alb" {
  for_each    = var.target_group
  name        = each.value.name
  target_type = "instance"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    matcher             = "200"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

##Creating EC2 Instances
resource "aws_instance" "ec2" {
  for_each = var.ec2_instance

  ami                         = "ami-0f58b397bc5c1f2e8"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[each.value.subnet].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  user_data                   = base64encode(file(each.value.user_data))

  tags = {
    Name = each.key
  }
}

##Register EC2 Instance with Target Group
resource "aws_lb_target_group_attachment" "tg_attach" {
  for_each = var.tg_attachment

  target_group_arn = aws_lb_target_group.tg_alb[each.value.tg].arn
  target_id        = aws_instance.ec2[each.value.ec2].id ##instance Id
  port             = 80
}

##Creating Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = values(aws_subnet.public)[*].id
  tags = {
    Name = "alb"
  }
}

##Creating ALB Listener
#tfsec:ignore:aws-elb-http-not-used Reason: This is a demo environment and we are using HTTP for simplicity. In production, HTTPS should be used for secure communication.
resource "aws_lb_listener" "alb_listener" {
  depends_on = [aws_lb.alb]

  load_balancer_arn = aws_lb.alb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb["target1"].id
  }
}

##Path Based Routing Policy
resource "aws_lb_listener_rule" "alb_listner_rule" {
  for_each = var.listener_rule

  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = each.value.priority

  condition {
    path_pattern {
      values = [each.value.path]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_alb[each.value.tg].arn
  }
}