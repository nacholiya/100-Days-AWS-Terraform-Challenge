# Day 09 – EC2 Launch Templates with Terraform

## What This Builds
This module creates an **EC2 Launch Template** using Terraform, enabling standardized,
versioned, and repeatable EC2 instance configurations for scalable and immutable
infrastructure deployments.

## AWS Services Used
- Amazon EC2

## Resources Created
- EC2 Launch Template

## Architecture
Terraform → EC2 Launch Template → Versioned Instance Configuration

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

- Difference between Launch Templates and Launch Configurations
- How Launch Templates support Auto Scaling Groups
- Importance of Immutable infrastructure