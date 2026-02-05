# Day 08 – Amazon EBS with EC2 using Terraform

## What This Builds
This module provisions an EC2 instance with an attached Amazon EBS volume
using Terraform, demonstrating persistent block storage for compute workloads.

## AWS Services Used
- Amazon EC2
- Amazon EBS (Elastic Block Store)

## Resources Created
- EC2 Instance
- EBS Volume
- EBS Volume Attachment
- Security Group

## Architecture
Terraform  
→ EC2 Instance  
→ Attached EBS Volume  
→ Persistent Block Storage

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

- Deffirence between root vloume and additional EBS volumes
- How to attach EBS volumes to EC2 Instance
- Common EBS volume types ( gp3, gp2, io1, io2 )
- Persistance stroage independent of EC2 lifecycle