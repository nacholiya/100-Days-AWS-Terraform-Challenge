resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-19-vpc"
  }
}

resource "aws_subnet" "pb_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "day-19-pb-subnet-1"
  }
}

resource "aws_subnet" "pb_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "day-19-pb-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-19-igw"
  }
}

resource "aws_route_table" "publie_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-19-public-rt"
  }
}

resource "aws_route_table_association" "rt_assoc_1" {
  subnet_id      = aws_subnet.pb_subnet_1.id
  route_table_id = aws_route_table.publie_rt.id
}

resource "aws_route_table_association" "rt_assoc_2" {
  subnet_id      = aws_subnet.pb_subnet_2.id
  route_table_id = aws_route_table.publie_rt.id
}

resource "aws_security_group" "alb_sg" {
  name        = "day-19-alb-sg"
  description = "Allow HTTP Traffic"
  vpc_id      = aws_vpc.main.id

  #tfsec:ignore:aws-ec2-no-public-ingress-sgr Reason: ALB must be publicly accessible for Route53 traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr Reason: ALB requires outbound access to communicate with targets
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day-19-alb-sg"
  }
}

resource "aws_lb" "app_alb" {
  name               = "day-19-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.pb_subnet_1.id, aws_subnet.pb_subnet_2.id]

  tags = {
    Name = "day-19-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "day-19-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

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
    Name = "day-19-tg"
  }
}

#tfsec:ignore:aws-elb-http-not-used Reason: This is a demo environment and we are using HTTP for simplicity. In production, HTTPS should be used for secure communication.
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_route53_zone" "day19_zone" {
  name = "day19.internal"
}

resource "aws_route53_record" "app_alias" {
  zone_id = aws_route53_zone.day19_zone.zone_id
  name    = "app.day19.internal"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}