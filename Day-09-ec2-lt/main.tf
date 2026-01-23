resource "aws_launch_template" "tf_lt" {
  name_prefix   = "day-09-tf-"
  image_id      = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.micro"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "tf-ec2-lt-v2"
    }
  }
}