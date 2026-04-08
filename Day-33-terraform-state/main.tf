##Creating Virual Private Cloud ( VPC )
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day33-vpc"
  }
}

##Creating Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "day-33-public-subnet"
  }
}

##Creating Internet Gateway ( IGW )
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-33-igw"
  }
}

##Creating Route Table and Route
resource "aws_route_table" "publit_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "day-33-public-rt"
  }
}

##Associating Route Table 
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.publit_rt.id
}

##Creating Security Group
resource "aws_security_group" "tf_sg" {
  name   = "tf-sg"
  vpc_id = aws_vpc.main.id

  ##Inbound Rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "SSH Open"
  }

  ##Outbound Rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    description = "All Ports Open"
  }

  tags = {
    Name = "day-33-sg"
  }
}

##creating EC2 Instance
resource "aws_instance" "tf_ec2" {
  ami                    = "ami-019715e0d74f695be" ##Ubuntu
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.tf_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "day-33-ec2-instance"
  }
}