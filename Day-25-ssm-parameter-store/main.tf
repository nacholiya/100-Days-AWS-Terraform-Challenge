data "aws_caller_identity" "current" {

}

data "aws_region" "region" {

}

resource "aws_ssm_parameter" "foo" {
  name  = "/app/environment"
  type  = "String"
  value = "dev"
}

resource "aws_kms_key" "key" {
  description         = "KMS key for encrypting SSM SecureString parameters"
  enable_key_rotation = true
}

resource "aws_ssm_parameter" "too" {
  name   = "/app/db_password"
  type   = "SecureString"
  value  = "MySecurePass123"
  key_id = aws_kms_key.key.arn
}

resource "aws_iam_policy" "parameters_access" {
  name        = "day-25-paramater-access-policy"
  description = "Read only assecc to Day-25 prameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ]
      Resource = "arn:aws:ssm:${data.aws_region.region.name}:${data.aws_caller_identity.current.account_id}:parameter/app/*"
      },
      { Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.key.arn
      }
    ]
  })
}

resource "aws_iam_role" "ec2" {
  name = "ec2-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.parameters_access.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  role = aws_iam_role.ec2.name
  name = "day-25-ec2-instance-profile"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "day-25-key-pair"
  public_key = file("day-25-key-pair.pub")
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-25-vpc"
  }
}

resource "aws_subnet" "public" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "day-25-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-25-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-25-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
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
    Name = "day-25-ec2-sg"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key_pair.key_name

  tags = {
    Name = "day-25-ec2-instance"
  }
}