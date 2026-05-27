resource "aws_ecs_cluster" "ecs_cluster" {
  name = "Day-57-ecs-cluster"
}

resource "aws_iam_role" "ecs_role" {
  name = "day-57-ecs-role"
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

resource "aws_ecs_task_definition" "ecs_task_defination" {
  family = "Day-57"
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

resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_subnet" "ecs_subnet" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.ecs_vpc.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
}

resource "aws_route_table" "ecs_rt" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
}

resource "aws_route_table_association" "ecs_rt_association" {
  route_table_id = aws_route_table.ecs_rt.id
  subnet_id      = aws_subnet.ecs_subnet.id
}

resource "aws_security_group" "ecs_sg" {
  name   = "Day-57-ecs-vpc"
  vpc_id = aws_vpc.ecs_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["10.0.0.0/16"]
    protocol    = "tcp"
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
  }
}

resource "aws_ecs_service" "ecs_service" {
  cluster         = aws_ecs_cluster.ecs_cluster.id
  name            = "Day-57-2048"
  task_definition = aws_ecs_task_definition.ecs_task_defination.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.ecs_subnet.id]
  }
}