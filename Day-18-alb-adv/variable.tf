variable "public_subnet" {
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

variable "target_group" {
  default = {
    target1 = {
      name = "tg-app1"
    }
    target2 = {
      name = "tg-app2"
    }
  }
}

variable "ec2_instance" {
  default = {
    ec2_1 = {
      subnet    = "subnet1"
      user_data = "user-data-app1.sh"
    }
    ec2_2 = {
      subnet    = "subnet2"
      user_data = "user-data-app2.sh"
    }
  }
}

variable "tg_attachment" {
  default = {
    tg_attachment_1 = {
      tg  = "target1"
      ec2 = "ec2_1"
    }
    tg_attachment_2 = {
      tg  = "target2"
      ec2 = "ec2_2"
    }
  }
}

variable "listener_rule" {
  default = {
    rule_1 = {
      priority = 10
      path     = "/app1/*"
      tg       = "target1"
    }
    rule_2 = {
      priority = 20
      path     = "/app2/*"
      tg       = "target2"

    }
  }
}