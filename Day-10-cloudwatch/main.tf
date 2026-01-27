##Creating IAM Role for EC2 to access CloudWatch
resource "aws_iam_role" "tf_ec2_cloudwatch_role" {
  name = "tf-ec2-cloudwatch-role"
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

##Attach CloudWatch Agent policy
resource "aws_iam_role_policy_attachment" "cw_agent_policy" {
  role       = aws_iam_role.tf_ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

## Create Instance Profile
resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.tf_ec2_cloudwatch_role.name
}

##Creating Log Group for EC2 logs
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/ec2/application"
  retention_in_days = 7
}

##Creating Launch Template with Cloudwatch Enabled
resource "aws_launch_template" "cloudwatch_lt" {
  name_prefix   = "cloudwatch-lt-"
  image_id      = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (Mumbai)
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_cloudwatch_profile.name
  }

  user_data = base64encode(file("user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cloudwatch-enabled-ec2"
    }
  }
}

## Create VPC
resource "aws_vpc" "cloudwatch_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cloudwatch-vpc"
  }
}

## Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cloudwatch_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cloudwatch-public-subnet"
  }
}

## Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudwatch_vpc.id

  tags = {
    Name = "cloudwatch-igw"
  }
}

## Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudwatch_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "cloudwatch-public-rt"
  }
}

## Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

## Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "cloudwatch-ec2-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.cloudwatch_vpc.id

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
    Name = "cloudwatch-ec2-sg"
  }
}

## Launch EC2 instance using Launch Template
resource "aws_instance" "cloudwatch_ec2" {
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  launch_template {
    id      = aws_launch_template.cloudwatch_lt.id
    version = "$Latest"
  }

  tags = {
    Name = "cloudwatch-ec2"
  }
}
