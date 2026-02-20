# Day 15 – VPC Advanced (Private Subnets & NAT Gateway) with Terraform

## What This Builds
This module provisions an advanced VPC architecture with **public and private subnets**
using Terraform. It includes a **NAT Gateway** to allow private instances to access the
internet securely without being publicly exposed.

## AWS Services Used
- Amazon VPC
- Subnets (Public & Private)
- Internet Gateway (IGW)
- NAT Gateway
- Route Tables
- Elastic IP

## Resources Created
- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Elastic IP
- Route Tables (Public & Private)
- Route Table Associations

## Architecture
Internet → Internet Gateway → Public Subnet → NAT Gateway → Private Subnet → Private EC2 Instances (No Public IP)

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

- Difference between public and private subnets
- How NAT Gateway enbles outbound internet access for private resources
- Route table configuration for controlled traffic flow
- Why backend services should reside in private subnets