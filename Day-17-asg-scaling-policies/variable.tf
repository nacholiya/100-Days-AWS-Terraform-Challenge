variable "Public_subnet" {
  default = {
    subnet1 = {
      cidr_block = "10.0.1.0/24"
      az         = "ap-south-1a"
    }
    subnet2 = {
      cidr_block = "10.0.2.0/24"
      az         = "ap-south-1b"
    }
  }
}