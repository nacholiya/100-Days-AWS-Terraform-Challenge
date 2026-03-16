data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "../network-stack/terraform.tfstate"
  }
}

##Creating Security Group
resource "aws_security_group" "tf-sg" {
  name   = "day-32-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

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
    Name = "day-32-sg"
  }
}

##creating EC2 Instance
resource "aws_instance" "tf-ec2" {
  ami                    = "ami-019715e0d74f695be" ##Ubuntu
  instance_type          = "t2.micro"
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.sg_id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "day-32-ec2-instance"
  }
}