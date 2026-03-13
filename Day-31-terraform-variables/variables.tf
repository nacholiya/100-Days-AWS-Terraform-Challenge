variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region to deploy resources"
}

variable "environment" {
  type        = string
  description = "Set the required environment"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of instance"

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t2.small"], var.instance_type)
    error_message = "Instance type must be t2.micro, t2.small, or t3.micro"
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
}

variable "project_name" {
  type        = string
  description = "Name for the project"
}