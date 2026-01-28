# Day 02 – Amazon S3 with Terraform

## What This Builds
This module provisions an Amazon S3 bucket using Terraform with
versioning and encryption enabled to follow basic data security best practices.

## AWS Services Used
- Amazon S3
- AWS KMS (optional)

## Resources Created
- S3 Bucket
- Bucket Versioning
- Server-side Encryption

## Architecture
Terraform → Amazon S3 → Secure Object Storage

## How to Deploy
terraform init
terraform plan
terraform apply

## How to Clean Up
terraform destroy

## Key Learnings
- S3 bucket configuration using Terraform
- Importance of versioning for data protection
- Encryption at rest best practices
