variable "ami" {
  description = "AMI ID to launch the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance (e.g., t2.micro)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instance"
  type        = list(string)
}

variable "key_name" {
  description = "Name of the key pair to enable SSH access to the EC2 instance"
  type        = string
  default     = ""
}