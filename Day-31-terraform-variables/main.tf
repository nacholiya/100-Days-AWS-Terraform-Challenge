resource "aws_instance" "instance" {
  ami           = "ami-019715e0d74f695be"
  instance_type = var.instance_type
}