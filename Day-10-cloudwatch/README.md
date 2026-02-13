# Day 10 – CloudWatch Logs with Terraform

## What This Builds
This module sets up **centralized logging** for EC2 instances using **Amazon CloudWatch Logs**
with Terraform, enabling log collection, monitoring, and troubleshooting from a single place.

## AWS Services Used
- Amazon CloudWatch Logs
- Amazon EC2
- AWS IAM

## Resources Created
- CloudWatch Log Group
- IAM Role for EC2
- IAM Policy for CloudWatch Logs
- IAM Instance Profile

## Architecture
EC2 Instance → CloudWatch Agent → CloudWatch Log Group → Centralized Log Storage & Monitoring

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

- How EC2 sends logs to CloudWatch Logs
- Role of IAM permissions for log ingestion
- Difference between metrics, logs, and alarms