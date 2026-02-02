# Day 05 – Amazon EC2 with Terraform

## What This Builds
This module provisions an Amazon EC2 instance using Terraform, including key pair
authentication, security groups, and basic networking configuration.

## AWS Services Used
- Amazon EC2
- Amazon VPC
- Amazon Security Groups

## Resources Created
- EC2 Instance
- Key Pair
- Security Group

## Architecture
Terraform → VPC → Security Group → EC2 Instance

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

##How to Clean Up

```bash
terraform destroy
```

##Key Learnings

- EC2 instance lifecycle management using Terraform
- Importance of key pairs for secure SSH access
- Importance of key pairs for secure SSH access
