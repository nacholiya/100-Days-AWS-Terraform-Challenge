# Day 04 – Amazon VPC with Terraform

## What This Builds
This module provisions a custom **Amazon Virtual Private Cloud (VPC)** using Terraform,
including basic networking components required to enable internet connectivity for AWS resources.

## AWS Services Used
- Amazon VPC
- Amazon Subnet
- Internet Gateway
- Route Table

## Resources Created
- VPC  
- Public Subnet  
- Internet Gateway (IGW)  
- Route Table  
- Route Table Association  

## Architecture
Terraform → VPC → Subnet → Route Table → Internet Gateway → Internet

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

- What a VPC is and why it’s required

- Role of Internet Gateway and Route Tables

- How internet access is enabled inside a VPC