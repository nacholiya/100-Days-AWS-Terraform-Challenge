variable "public_subnet" {
  default = {
    subnet1 = {
      cidr = "10.0.1.0/24"
      az   = "ap-south-1a"
    }
    subnet2 = {
      cidr = "10.0.2.0/24"
      az   = "ap-south-1b"
    }
  }
}

variable "instance_type" {
  description = "EC2 Instance type for Auto Scalling Group"
  type        = string
  default     = "t3.micro"
}