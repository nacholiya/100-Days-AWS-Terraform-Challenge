resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name != "" ? var.key_name : null
  user_data              = <<-EOF
                #!/bin/bash
                apt update -y
                apt install -y nginx
                systemctl start nginx
                systemctl enable nginx
                echo "Hello from Terraform EC2 vis ALB " > /var/www/html/index.html
                EOF

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "day-37-instace"
  }
}