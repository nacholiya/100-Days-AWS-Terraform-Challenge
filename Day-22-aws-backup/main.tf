resource "aws_backup_vault" "backup_vault" {
  name = "day-22-aws-backup-vault"

  tags = {
    Name = "day-22-aws-backup-vault"
  }
}

resource "aws_backup_plan" "backup_plan" {
  name = "aws-backup-plan"

  rule {
    rule_name         = "day-22-aws-backup-rule"
    target_vault_name = aws_backup_vault.backup_vault.name
    schedule          = "cron(0 12 * * ? *)"
    start_window      = 60
    completion_window = 180

    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_iam_role" "backup_role" {
  name = "day-22-aws-backup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_selection" "backup_slection" {
  name         = "day-22-backup-selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.backup_plan.id
  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}

##Creating Virual Private Cloud ( VPC )
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day22-vpc"
  }
}

##Creating Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "day-22-public-subnet"
  }
}

##Creating Internet Gateway ( IGW )
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "day-22-igw"
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
    Name = "day-22-public-rt"
  }
}

##Associating Route Table 
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.publit_rt.id
}

##Creating Security Group
resource "aws_security_group" "ec2-sg" {
  name   = "ec2-sg"
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
    Name = "day-22-ec2-sg"
  }
}

##creating EC2 Instance
resource "aws_instance" "ec2" {
  ami                    = "ami-019715e0d74f695be" ##Ubuntu
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name   = "day-22-ec2-instance"
    Backup = "true"
  }
}