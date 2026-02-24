# Day 17 – ASG Scaling Policies with Terraform

## What This Builds
This module configures Auto Scaling Group (ASG) scaling policies using
Target Tracking and Step Scaling based on CPU utilization metrics
to automatically adjust EC2 capacity.

## AWS Services Used
- Amazon EC2
- Auto Scaling Group (ASG)
- Application Load Balancer (if attached)
- Amazon CloudWatch

## Resources Created
- Launch Template (if required)
- Auto Scaling Group
- Target Tracking Scaling Policy
- Step Scaling Policy
- CloudWatch Alarm for scaling triggers

## Architecture
CloudWatch CPU Metrics → Scaling Policy → Auto Scaling Group → EC2 Instances Scale In / Scale Out Automatically

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify

- Generate CPU load on EC2 instance
- Monitor CloudWatch CPU metrics
- Observe automatic scale-out when threshold exceeds
- Observe scale-in when CPU drops

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Difference between Target Tracking and Step Scalling
- How CloudWatch metrics trigger scalling events 
- Maintaining high availability with auto-scalling