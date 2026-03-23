variable "subnet_ids" {
  description = "List of subnet IDs where the Application Load Balancer will be deployed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the Application Load Balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID in which the target group will be created"
  type        = string
}

variable "port" {
  description = "Port on which the load balancer and target group will listen"
  type        = number
}

variable "protocol" {
  description = "Protocol used by the load balancer and target group (e.g., HTTP)"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal (true) or internet-facing (false)"
  type        = bool
}