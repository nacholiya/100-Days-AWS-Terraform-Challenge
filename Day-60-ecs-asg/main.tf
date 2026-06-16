resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "pub_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "pub_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt_assoc_1" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub_subnet_1.id
}

resource "aws_route_table_association" "rt_assoc_2" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub_subnet_2.id
}

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.vpc.id

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
  vpc_id = aws_vpc.vpc.id

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

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "day-60-ecr-repo"
  image_tag_mutability = "MUTABLE"
  # force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "ecs" {
  name = "Day-60-ecs-cluster"
}

resource "aws_iam_role" "task_execution_role" {
  name = "Day-60-task-execution-role"

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
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "Day-60"

  container_definitions = jsonencode(
    [
      {
        name      = "Day-60-container"
        image     = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
        essential = true

        portMappings = [
          {
            containerPort = 80
            # hostPort      = 80
            protocol = "tcp"
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-region        = "ap-south-1"
            awslogs-stream-prefix = "ecs"
            awslogs-group         = aws_cloudwatch_log_group.cw_log_grp.name
          }
        }
      }
    ]
  )

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_cloudwatch_log_group" "cw_log_grp" {
  name              = "Day-60-ecs-log-grp"
  retention_in_days = 1
}

resource "aws_ecs_service" "ecs_service" {
  name            = "Day-60-svc"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
    container_name   = "Day-60-container"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.ecs_alb_listner
  ]
}

resource "aws_lb" "ecs_alb" {
  name               = "Day-60-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
}

resource "aws_lb_target_group" "ecs_alb_tg" {
  name        = "Day-60-ecs-tg"
  vpc_id      = aws_vpc.vpc.id
  protocol    = "HTTP"
  port        = 80
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
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

resource "aws_appautoscaling_target" "ecs_ast" {
  min_capacity       = 1
  max_capacity       = 3
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_asp" {
  name               = "ecs-scalling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_ast.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_ast.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_ast.service_namespace

  target_tracking_scaling_policy_configuration {
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 50
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}