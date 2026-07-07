resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Day-63-vpc"
  }
}

resource "aws_subnet" "pvt_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Day-63-private-subnet-1"
  }
}

resource "aws_subnet" "pvt_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Day-63-private-subnet-2"
  }
}

resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Day-63-public-subnet"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-sub-grp"
  subnet_ids = [aws_subnet.pvt_subnet_1.id, aws_subnet.pvt_subnet_2.id]

  tags = {
    Name = "Day-63-db-subnet-group"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Day-63-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "Day-63-public-route-table"
  }
}

resource "aws_route_table_association" "pub_rt_association" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.vpc.id

  #tfsec:ignore:aws-ec2-no-public-ingress-sgr Reason: ALB must be publicly accessible
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  #tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "Day-63-bastion-security-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    security_groups = [aws_security_group.bastion_sg.id]
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
  }

  tags = {
    Name = "Day-63-rds-security-group"
  }
}

resource "aws_db_instance" "db" {
  engine                    = "mysql"
  engine_version            = "8.4"
  instance_class            = "db.t3.micro"
  allocated_storage         = 20
  db_name                   = "day63_db"
  password                  = var.db_password
  username                  = "admin"
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible       = false
  multi_az                  = false
  identifier                = "day-63-rds-instance"
  storage_type              = "gp3"
  backup_retention_period   = 7
  deletion_protection       = true
  storage_encrypted         = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "rds-snapshot"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "baiston_keypair"
  public_key = file("${path.module}/bastion_keypair.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion_host" {
  key_name               = aws_key_pair.key_pair.key_name
  instance_type          = "t3.micro"
  ami                    = data.aws_ami.ubuntu.id
  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = "Day-63-bastion-ec2"
  }
}