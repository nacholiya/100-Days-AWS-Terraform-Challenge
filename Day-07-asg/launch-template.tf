##Launch Template for Auto Scalling Group
resource "aws_launch_template" "tf_lt" {
  name_prefix   = "tf-asg-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  user_data = base64encode(file("user-data.sh"))

  vpc_security_group_ids = [aws_security_group.tf_asg_ec2_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tf-asg-instance"
    }
  }
}