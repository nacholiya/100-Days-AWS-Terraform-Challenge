resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Day-61-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Day-61-igw"
  }
}

resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub_subnet.id
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.vpc.id

  #tfsec:ignore:aws-ec2-no-public-ingress-sgr Reason: ALB must be publicly accessible
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }

  #tfsec:ignore:aws-ec2-no-public-ingress-sgr Reason: ALB must be publicly accessible
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "Day-61-ec2-sg"
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "Day-61-ec2-iam-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "Day-61-iam-role-instance-profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_ecs_cluster" "ec2_cluster" {
  name = "Day-61-ecs-cluster"
}

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-ebs"]
  }
}

resource "aws_instance" "ecs_ec2" {
  ami                    = data.aws_ami.ecs.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  user_data              = file("${path.module}/user-data.sh")

  tags = {
    Name = "Day-61-ecs-ec2-instance"
  }
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "Day-61"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"

  container_definitions = jsonencode(
    [
      {
        name      = "nginx-container"
        image     = "nginx"
        essential = true

        cpu    = 256
        memory = 512

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
}

resource "aws_ecs_service" "nginx_service" {
  name            = "Day-61-svc"
  cluster         = aws_ecs_cluster.ec2_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "EC2"
}