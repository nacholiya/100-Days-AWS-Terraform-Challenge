##Creating KeyPair
resource "aws_key_pair" "tf-key" {
  key_name   = "tf-keypair"
  public_key = file("tf-keypair.pub")
}

##Creating Virual Private Cloud ( VPC )
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-day05-vpc"
  }
}

##Creating Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "tf-public-subnet"
  }
}

##Creating Internet Gateway ( IGW )
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-igw"
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
    Name = "tf-public-rt"
  }
}

##Associating Route Table 
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.publit_rt.id
}

##Creating Security Group
resource "aws_security_group" "tf-sg" {
  name   = "tf-sg"
  vpc_id = aws_vpc.main.id

  ##Inbound Rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
  }

  ##Outbound Rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All Ports Open"
  }

  tags = {
    Name = "tf-sg"
  }
}

##creating EC2 Instance
resource "aws_instance" "tf-ec2" {
  ami                    = "ami-019715e0d74f695be" ##Ubuntu
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.tf-key.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.tf-sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "tf-ec2-instance"
  }
}