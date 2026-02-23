# Day 16 – Bastion Host with Terraform

## What This Builds
This module provisions a Bastion Host (Jump Server) in a public subnet
to securely access EC2 instances deployed in private subnets via SSH.

## AWS Services Used
- Amazon EC2
- Amazon VPC
- Security Groups
- Internet Gateway

## Resources Created
- Bastion Host EC2 Instance (Public Subnet)
- Private EC2 Instance (Private Subnet)
- Security Groups with restricted SSH access
- Key Pair

## Architecture
Internet → Bastion Host (Public Subnet) → Private EC2 (Private Subnet) → Secure SSH Access

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify
1. SSH into Bastion Host (public IP).
2. From Bastion, SSH into private EC2 using private IP.
3. Confirm private EC2 has no public IP

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- What Bastion host (Jump Server) is
- Security Group chaining (allow SSH only from Bastion SG)
- Real-world secure network architecture design