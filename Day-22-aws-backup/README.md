# Day 22 - AWS Backup for EC2 & EBS with Terraform

## What This Builds

This module provisions an automated backup solution using AWS Backup to 
project EC2 instances and attached EBS volumes with scheduled backup plans. 

## AWS Services Used

- AWS Backup
- Amazon EC2
- Amazon EBS
- AWS IAM

## Resources Created

- Backup Vault
- Backup Plan
- Backup Rule ( Schedule )
- Backup Selection
- IAM Role for Backup SService

## Architecture

EC2 Instance
→ EBS Volume
→ AWS Backup Plan
→ Backup Vault 
→ Scheduled Snapshots

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify

- Open AWS Backup console
- Check Backup Vault
- Confirm scheduled recovery points are created
- Verify EC2/EBS resources are protected

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Centralized backup managment using AWS Backup
- Automating backups for EC2 and EBS
- Importance of disaster recovery planning