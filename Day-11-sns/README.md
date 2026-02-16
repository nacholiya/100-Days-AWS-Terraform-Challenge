# Day 11 – SNS + CloudWatch Alarm with Terraform

## What This Builds
This module provisions **Amazon CloudWatch Alarms** integrated with **Amazon SNS**
using Terraform to send notifications when EC2 metrics cross defined thresholds,
enabling proactive monitoring and alerting.

## AWS Services Used
- Amazon CloudWatch
- Amazon SNS
- Amazon EC2

## Resources Created
- CloudWatch Metric Alarm
- SNS Topic
- SNS Subscription (Email)
- IAM permissions (if required)

## Architecture
EC2 Instance  
→ CloudWatch Metric  
→ CloudWatch Alarm  
→ SNS Topic  
→ Email Notification

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

- Difference between monitoring and alerting
- How CloudWatch alarms work with metrics
- Using SNS for real-time notifications
- Common alerting use cases in production (CPU, memory, disk)
- Importance of proactive incident detection