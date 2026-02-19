# Day 14 – Advanced S3 with IAM Role (Least Privilege Access)

## What This Builds
This module provisions a secure Amazon S3 bucket and allows an EC2 instance to access it using an IAM Role. The setup follows the principle of least privilege and avoids the use of static AWS credentials.

## AWS Services Used
- Amazon S3
- AWS Identity and Access Management (IAM)
- Amazon EC2
- AWS Security Token Service (STS)

## Resources Created
- S3 Bucket (Versioning Enabled)
- S3 Server-Side Encryption
- S3 Public Access Block
- IAM Policy (S3 Least Privilege)
- IAM Role
- IAM Role Policy Attachment
- IAM Instance Profile
- EC2 Instance with IAM Role attached

## Architecture
Terraform → IAM Role → Instance Profile →
EC2 → STS AssumeRole → S3 Bucket (Secure Access)

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify
- SSH into the EC2 Instance
- Upload a file to S3:
```bash
aws s3 cp test.txt s3://your-bucket-name/
```
- Verify role identity:
```bash
aws sts get-caller-identity
```

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Secure S3 access without access keys
- Implementing least-privilege IAM policy
- Using IAM Role and Instance Profile for EC2
- Blocking public access on S3 buckets