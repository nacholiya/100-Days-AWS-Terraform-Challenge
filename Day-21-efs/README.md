# Day 21 – Amazon EFS with EC2 using Terraform

## What This Builds
This module provisions an Amazon Elastic File System (EFS) and mounts it to EC2 instances
to provide a shared, scalable, and persistent file system accessible by multiple servers.

## AWS Services Used
- Amazon EFS
- Amazon EC2
- Amazon VPC
- Security Groups

## Resources Created
- EFS File System
- Mount Targets
- EC2 Instances
- Security Group for EFS access
- User Data script to automatically mount EFS

## Architecture
EC2 Instance 1  
EC2 Instance 2  
        ↓  
Shared Amazon EFS File System  
        ↓  
Persistent Shared Storage

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify

- SSH into EC2
- Run:
  ```bash
  df -h 
  ```
- Confirms EFS mount point exists
- Create a file from one EC2 and verify it appears on another

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Difference between EFS and EBS
- SShared file systems for distributed applications
- Use case like shared logs, media storage, and container volumes