resource "aws_lb" "this" {
  name               = "alb-for-ec2"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
  internal           = var.internal
}

resource "aws_lb_target_group" "this" {
  name        = "alb-target-group"
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = "instance"
}

#tfsec:ignore:aws-elb-http-not-used Reason: HTTPS configured in later stages
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}