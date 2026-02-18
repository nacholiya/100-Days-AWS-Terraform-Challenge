# Day 13 – IAM Roles & Instance Profiles with Terraform

## What This Builds
This module provisions an IAM Role and Instance Profile using Terraform and attaches
least-privilege IAM policies. The role is associated with an EC2 instance to enable
secure, credential-free access to AWS services.

## AWS Services Used
- AWS Identity and Access Management (IAM)
- Amazon EC2
- AWS Security Token Service (STS)

## Resources Created
- IAM Role
- IAM Policy (Least Privilege)
- IAM Role Policy Attachment
- IAM Instance Profile
- EC2 Instance with IAM Role attached

## Architecture
Terraform → IAM Role → Instance Profile → EC2  
EC2 → STS AssumeRole → AWS Services (Secure Access)

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify

- SSH into the EC2 Instance
- Run AWS CLI commands without access keys
- Verify Role via:
```bash
aws sts get-caller-identity
```

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Difference betwee IAM Role and IAM User
- How EC2 instance securly assumes IAM Role using STS
- Implementing least-privilege access

