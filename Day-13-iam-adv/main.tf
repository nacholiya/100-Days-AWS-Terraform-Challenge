## Creating IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
  name = "day13-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

## Custom IAM Policy (S3 Read-Only)
resource "aws_iam_policy" "s3_read_only" {
  name        = "day13-s3-read-only"
  description = "Allow EC2 to read objects from S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

## Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "day13-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

##Creating Launch Template with iam Enabled
resource "aws_launch_template" "iam_lt" {
  name_prefix   = "iam-lt-"
  image_id      = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (Mumbai)
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "iam-enabled-ec2"
    }
  }
}

## Create VPC
resource "aws_vpc" "iam_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "iam-vpc"
  }
}

## Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.iam_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "iam-public-subnet"
  }
}

## Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.iam_vpc.id

  tags = {
    Name = "iam-igw"
  }
}

## Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.iam_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "iam-public-rt"
  }
}

## Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

## Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "iam-ec2-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.iam_vpc.id

  ingress {
    description = "SSH access"
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
    Name = "iam-ec2-sg"
  }
}

## Launch EC2 instance using Launch Template
resource "aws_instance" "iam_ec2" {
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  launch_template {
    id      = aws_launch_template.iam_lt.id
    version = "$Latest"
  }

  tags = {
    Name = "iam-ec2"
  }
}

## Attach S3 Read-Only Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}