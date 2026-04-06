resource "aws_security_group" "bad_sg" {
  name        = "bad_security_group"
  description = "This security group allows all inbound traffic, which is not secure."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["1.2.3.4/32"] # This allows SSH access from a specific IP, which is better than allowing all traffic.
    description = "Allow SSH access from a specific IP address."
  }
}