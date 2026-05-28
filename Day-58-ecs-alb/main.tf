resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "pub_sub_1" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route_table" "ecs_rt" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
}

resource "aws_route_table_association" "rt_assoc_1" {
  route_table_id = aws_route_table.ecs_rt.id
  subnet_id      = aws_subnet.pub_sub_1.id
}

resource "aws_route_table_association" "rt_assoc_2" {
  route_table_id = aws_route_table.ecs_rt.id
  subnet_id      = aws_subnet.pub_sub_2.id
}

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.ecs_vpc.id

  #tfsec:ignore:aws-ec2-no-public-ingress-sgr Reason: ALB must be publicly accessible
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.ecs_vpc.id

  ingress {
    security_groups = [aws_security_group.alb_sg.id]
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

resource "aws_lb" "ecs_alb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  internal           = false
  subnets            = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
}

resource "aws_lb_target_group" "ecs_alb_tg" {
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"

  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

#tfsec:ignore:aws-elb-http-not-used Reason: This is a demo environment and we are using HTTP for simplicity. In production, HTTPS should be used.
resource "aws_lb_listener" "ecs_alb_listner" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "Day-58-ecs-cluster"
}

resource "aws_iam_role" "ecs_role" {
  name = "day-58-ecs-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "policy_atttachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "Day-58"
  container_definitions = jsonencode(
    [
      {
        name      = "2048"
        image     = "cnrock/2048"
        essential = true
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          }
        ]
      }
    ]
  )

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_role.arn
  cpu                      = "256"
  memory                   = "512"
}

resource "aws_ecs_service" "ecs_service" {
  cluster         = aws_ecs_cluster.ecs_cluster.id
  name            = "Day-58-2048"
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
    container_name   = "2048"
    container_port   = 80
  }
}