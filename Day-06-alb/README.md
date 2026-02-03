# Day 06 – Application Load Balancer (ALB) with Terraform

## What This Builds
This module provisions an **AWS Application Load Balancer (ALB)** using Terraform to
distribute incoming HTTP traffic across multiple EC2 instances, improving availability
and fault tolerance.

## AWS Services Used
- Elastic Load Balancing (Application Load Balancer)
- Amazon EC2
- Amazon VPC
- Security Groups

## Resources Created
- Application Load Balancer
- Target Group
- Listener (HTTP :80)
- Security Group for ALB

## Architecture
User → ALB → Target Group → EC2 Instances

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Difference between ALB, NLB, and CLB
- How ALB routes traffic using listeners and target groups
- Importance of health checks for high availability
- How ALB integrates with EC2 and Auto Scaling