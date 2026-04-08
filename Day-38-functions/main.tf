## Use COUNT
resource "local_file" "local_count" {
  count    = 4
  filename = "day-38-file-${count.index}.txt"
  content  = "This is file from the index: ${count.index}"
}

## Use FOR_EACH
resource "local_file" "local_for_each" {
  for_each = toset(["app", "db", "cache"])
  filename = "day-38-${each.key}-file.txt"
  content  = "Hello! from ${each.key}"
}

## DYNAMIC BLOCK 

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "dynamic_sg" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = toset([22, 443, 80])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}