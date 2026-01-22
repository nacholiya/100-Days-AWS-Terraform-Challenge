##Creating SSH Key-Pair
resource "aws_key_pair" "tf_key_pair" {
  key_name   = "tf-key-pair"
  public_key = file("tf-key-pair.pub")
}

##Creating VPC
resource "aws_vpc" "tf_ec2_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-ec2-vpc"
  }
}

##Creating Public Subnet
resource "aws_subnet" "tf_pb_subnet" {
  vpc_id                  = aws_vpc.tf_ec2_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "tf_pb_subnet"
  }
}

##Creating Internet Gateway ( IGW )
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_ec2_vpc.id

  tags = {
    Name = "tf-igw"
  }
}

##Creating Route Table And Route
resource "aws_route_table" "tf_pb_rt" {
  vpc_id = aws_vpc.tf_ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
}

##Creating Route Table Association
resource "aws_route_table_association" "tf_pb_association" {
  subnet_id      = aws_subnet.tf_pb_subnet.id
  route_table_id = aws_route_table.tf_pb_rt.id
}

##Creating Security Group
resource "aws_security_group" "tf_ec2_sg" {
  name   = "tf-ec2-sg"
  vpc_id = aws_vpc.tf_ec2_vpc.id

  ##Inbound Rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open SSH"
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
    Name = "tf-ec2-sg"
  }
}

##Creating EC2 Instance
resource "aws_instance" "tf_ec2" {
  ami                    = "ami-019715e0d74f695be" ##Ubuntu
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.tf_key_pair.key_name
  subnet_id              = aws_subnet.tf_pb_subnet.id
  vpc_security_group_ids = [aws_security_group.tf_ec2_sg.id]
  user_data              = base64encode(file("user-data.sh"))

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "tf-ec2"
  }
}

##Creating EBS Volume
resource "aws_ebs_volume" "tf_ec2_data_volume" {
  availability_zone = aws_subnet.tf_pb_subnet.availability_zone
  size              = 10
  type              = "gp3"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "tf-ebs-volume"
  }
}

##Attach EBS to EC2
resource "aws_volume_attachment" "tf_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.tf_ec2_data_volume.id
  instance_id = aws_instance.tf_ec2.id

  depends_on = [
    aws_instance.tf_ec2,
    aws_ebs_volume.tf_ec2_data_volume
  ]
}