resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "vpc-cloudwatch-log-group"
  retention_in_days = 1

  tags = {
    Name = "day-29-log-group"
  }
}

resource "aws_iam_role" "role" {
  name = "vpc-cloudwatch-role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "vpc-flow-logs.amazonaws.com"
          }
        },
      ]
    }
  )

  tags = {
    Name = "day-29-vpc-cloudwatch-role"
  }
}

resource "aws_iam_policy" "flow_logs_policy" {
  name = "vpc-flow-logs-policy"

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
        }
      ]
    }
  )

  tags = {
    Name = "day-29-vpc-flow-logs-policy"
  }
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.flow_logs_policy.arn
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-29-vpc"
  }
}

resource "aws_subnet" "public" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "day-29-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-29-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-29-public_rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
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
    Name = "day-29-ec2-sg"
  }
}

resource "aws_instance" "ec2" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "day-29-ec2-instance"
  }
}

resource "aws_flow_log" "flow_logs" {
  iam_role_arn         = aws_iam_role.role.arn
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
}