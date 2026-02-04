# Day 07 – Auto Scaling Group (ASG) with Application Load Balancer

## What This Builds
This module provisions an Auto Scaling Group (ASG) integrated with an
Application Load Balancer (ALB) using Terraform to automatically scale EC2
instances based on demand and ensure high availability.

## AWS Services Used
- Amazon EC2
- Auto Scaling Group
- Application Load Balancer (ALB)
- Target Groups
- Launch Template
- Security Groups

## Resources Created
- Launch Template
- Auto Scaling Group
- Application Load Balancer
- Target Group
- Listener
- Security Groups

## Architecture
User Traffic → ALB → Target Group → Auto Scaling Group → EC2 Instances

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

- Difference between Launch Template and Launch Configuration
- How Auto Scaling improves availability and fault tolerance
- ASG integration with ALB target groups
- Horizontal scaling based on demand