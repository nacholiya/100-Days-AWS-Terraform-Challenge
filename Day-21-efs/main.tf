resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-21-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "day-21-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "day-21-public-subnet-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-21-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-21-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ec2_sg" {
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
    Name = "day-21-ec2-sg"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "day-21-key-pair"
  public_key = file("day21-key.pub")

  tags = {
    Name = "day-21-key-pair"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = "ami-019715e0d74f695be"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/user-data-1.sh",
    {
      efs_dns = aws_efs_file_system.efs.dns_name
  })

  tags = {
    Name = "day-21-ec2-instance"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami                         = "ami-019715e0d74f695be"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/user-data-2.sh", {
    efs_dns = aws_efs_file_system.efs.dns_name
  })

  tags = {
    Name = "day-21-ec2-instance-2"
  }
}

resource "aws_efs_file_system" "efs" {
  encrypted        = true
  performance_mode = "generalPurpose"

  tags = {
    Name = "day-21-efs"
  }
}

resource "aws_security_group" "efs_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day-21-efs-sg"
  }
}

resource "aws_efs_mount_target" "mount_1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mount_2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.public_subnet_2.id
  security_groups = [aws_security_group.efs_sg.id]
}