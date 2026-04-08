##Creating VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day-16-vpc"
  }
}

##Creating Public Subnet for **Bastion**
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "day-16-public-subnet"
  }
}

##Creating Private Subnet for Application
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "day-16-private-subnet"
  }
}

##Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-16-igw"
  }
}

## Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-16-public-rt"
  }
}

##Associate Public Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

##Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "day-16-nat-eip"
  }
}

##NAT Gateway ( In Public Subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "day-16-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

##Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "day-16-private-rt"
  }
}

##Associate Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

##Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "day-16-bastion-sg"
  description = "Allow SSH from My IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = [var.your_ip]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH form my Ip"
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr Reason: Bastion host requires outbound internet access for updates and SSH operations
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day-16-bastion-sg"
  }
}

##Private EC2 Security Group
resource "aws_security_group" "private_ec2_sg" {
  name        = "day-16-private-ec2-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow SSH only from Bastion"

  ingress {
    security_groups = [aws_security_group.bastion_sg.id]
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    description     = "SSH from Bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "day-16-private-ec2-sg"
  }
}

##Key Pair for SSH
resource "aws_key_pair" "bastion_key" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = "day-16-key-pair"
  public_key = var.create_key_pair ? file("day-16-key-pair.pub") : null
}

##Bastion EC2
resource "aws_instance" "bastion" {
  ami                         = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (Mumbai)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.create_key_pair ? aws_key_pair.bastion_key[0].key_name : null
  associate_public_ip_address = true

  tags = {
    Name = "day-16-bastion"
  }
}

## Private EC2
resource "aws_instance" "private_ec2" {
  ami                    = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (Mumbai)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  key_name               = var.create_key_pair ? aws_key_pair.bastion_key[0].key_name : null

  tags = {
    Name = "day-16-private-ec2"
  }
}