# 🚀 100 Days of Terraform with AWS

> A hands-on, production-focused Terraform + AWS challenge with daily infrastructure builds and clean teardown.


**Progress:** Day 61 / 100 🚀 &nbsp;
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?style=for-the-badge)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Consistency-Daily%20Push-success?style=for-the-badge)

📅 **Start Date:** 13 Jan 2026  
🛑 **Break Days:** Saturday & Sunday (No tasks)  
🎯 **Goal:** Design, deploy, and manage AWS infrastructure using Terraform with real-world DevOps practices 

---

## 📌 About This Challenge

This repository documents my **100 Days of Terraform + AWS Challenge**.

### Engineering Principles:
- ✅ Terraform-only (Infrastructure as Code)
- ✅ Consistent GitHub commits (except weekends)
- ✅ Real AWS services (production mindset)
- ✅ Cost-aware infrastructure (free-tier & cleanup focused)

This challenge focuses on **consistency, depth, and real-world DevOps skills**.

---

## 🛠️ Tools & Technologies

- **Infrastructure** : **Terraform**
- **Cloud Provider** : **AWS**
- **Version Control** : **Git & GitHub**
- **OS** : **Linux (Ubuntu)**
- **Editor** : **VS Code**

---

## 📆 Progress Tracker (Updated Daily)

> ⏸️ **Note:** Saturdays & Sundays are OFF days

> 📌 Each day includes Terraform code, AWS best practices, and cleanup steps.


| Day | Topic | Description | Status | Code |
|:-----:|:------:|:------------:|:--------:|:------:|
| 01 | IAM Basics | IAM User, Policy, Access Key | ✅ | [View](./Day-01-iam) |
| 02 | S3 | Bucket, Versioning, Encryption | ✅ | [View](./Day-02-s3) |
| 03 | DynamoDB | Create DynamoDB Table | ✅ | [View](./Day-03-dynamobd) |
| 04 | VPC | VPC, Subnet, IGW, Route Tables | ✅ | [View](./Day-04-vpc) |
| 05 | EC2 | EC2, Key Pair, SG, Networking | ✅ | [View](./Day-05-ec2) |
| 06 | ALB | Application Load Balancer | ✅ | [View](./Day-06-alb) |
| 07 | ASG | Auto Scaling Group + ALB | ✅ | [View](./Day-07-asg) |
| 08 | EBS | EC2 with Attached EBS Volume | ✅ | [View](./Day-08-ec2+ebs) |
| 09 | EC2 Launch Templates | Versioned EC2 launch configs, immutable updates | ✅ | [View](./Day-09-ec2-lt/) |
| 10 | CloudWatch Logs | Centralized EC2 logging with CloudWatch Agent | ✅ | [View](./Day-10-cloudwatch) |
| 11 | SNS + CloudWatch Alarm | CPU-based alerting with SNS notifications | ✅ | [View](./Day-11-sns) |
| 12 | CloudWatch Dashboards | EC2 metrics visualization using CloudWatch dashboards | ✅ | [View](./Day-12-cw-dashboard/) |
| 13| IAM Roles & Instance Profiles | EC2 IAM role with least-privilege access verified via STS assume-role | ✅ | [View](./Day-13-iam-adv/) |
| 14 | IAM Least Privilege | Bucket-scoped IAM policy with removal of broad S3 permissions | ✅ | [View](./Day-14-s3-adv) |
| 15 | VPC Advanced | Public & private subnets with NAT Gateway for secure outbound access | ✅ | [View](./Day-15-vpc-adv/) |
| 16 | Bastion Host | Secure SSH access to private EC2 via bastion host | ✅ | [View](./Day-16-bastion-private-ec2/) |
| 17 | ASG Scaling Policies | Target tracking and step scaling based on CPU utilization | ✅ | [View](./Day-17-asg-scaling-policies/) |
| 18 | ALB Advanced | Path-based routing using Application Load Balancer | ✅ | [View](./Day-18-alb-adv/) |
| 19 | Route 53 | Hosted zones and ALB alias records without custom domain | ✅ | [View](./Day-19-route53) |
| 20 | ACM | Enable HTTPS on ALB using AWS Certificate Manager | ✅ | [View](./Day-20-acm/) |
| 21 | EFS | Shared file system for EC2 using Amazon EFS with automated mounting via user data | ✅ | [View](./Day-21-efs) |
| 22 | AWS Backup | Automated backups for EC2 and EBS | ✅ | [View](./Day-22-aws-backup/) |
| 23 | KMS | Customer-managed keys for encryption at rest | ✅ | [View](./Day-23-kms/) |
| 24 | Secrets Manage | Secure storage and retrieval of secrets | ✅ | [View](./Day-24-secrets-manager/) |
| 25 | SSM Parameter Store | Store configuration securely without hardcoding | ✅ | [View](./Day-25-ssm-parameter-store) |
| 26 | Systems Manager | Secure EC2 access using Session Manager (no SSH) | ✅ | [View](./Day-26-ssm-session-manager) |
| 27 | CloudTrail | Account activity logging with S3 storage | ✅ | [View](./Day-27-cloudtrail) |
| 28 | GuardDuty | Threat detection & security findings | ✅ | [View](./Day-28-guardduty) |
| 29 | VPC Flow Logs | Network traffic monitoring & visibility | ✅ | [View](./Day-29-vpc-flow-logs) |
| 30 | AWS Config | Resource compliance & configuration tracking | ✅ | [View](./Day-30-aws-config) |
| 31 | Terraform Variables | Inputs, defaults and validation rules | ✅ | [View](./Day-31-terraform-variables) |
| 32 | Terraform Outputs | Create and use Terraform outputs for cross-stack infrastructure | ✅ | [View](./Day-32-terraform-outputs) |
| 33 | Terraform State | Local state management and drift detection | ✅ | [View](./Day-33-terraform-state) |
| 34 | Terraform Backend | Remote state with S3 + DynamoDB locking | ✅ | [View](./Day-34-terraform-backend) |
| 35 | Terraform Workspaces | Multi-environment infra (dev/stage/prod) | ✅ | [View](./Day-35-workspaces) |
| 36 | Terraform Modules | Reusable VPC module | ✅ | [View](./Day-36-vpc-module) |
| 37 | Terraform Modules | EC2 & ALB modular infrastructure | ✅ | [View](./Day-37-terraform-modules) |
| 38 | Terraform Functions | for_each, count, dynamic blocks | ✅ | [View](./Day-38-functions) |
| 39 | Terraform Lifecycle | Safe updates & zero-downtime deployments | ✅ | [View](./Day-39-lifecycle) |
| 40 | Terraform Import | Manage existing AWS resources using Terraform | ✅ | [View](./Day-40-import) |
| 41 | Terraform Graph | Visualizing resource dependencies using implicit & explicit dependencies | ✅ | [View](./Day-41-terraform-graph) |
| 42 | Terraform Testing | Validate, Fmt, Plan Workflow | ✅ | [View](./Day-42-testing) |
| 43 | GitHub Actions | Terraform CI pipeline ( fmt check, init, validate ) | ✅ | [View](./.github/workflows/terraform-ci.yml) |
| 44 | Terraform Security | tfsec scanning for IaC security | ✅ | [View](./Day-44-security) |
| 45 | Cost Optimization | AWS Budgets and cost alerts | ✅ | [View](./Day-45-cost) |
| 46 | S3 Advanced | Lifecycle rules & intelligent tiering | ✅ | [View](./Day-46-s3-advanced) |
| 47 | S3 Access Logs | Logging and audit of bucket access | ✅ | [View](./Day-47-s3-logs) |
| 48 | CloudFront | CDN for S3 static website | ✅ | [View](./Day-48-cloudfront) |
| 49 | WAF | Protect application using Web Application Firewall | ✅ | [View](./Day-49-waf) |
| 50 | API Gateway | Build REST API infrastructure | ✅ | [View](./Day-50-api) |
| 51 | Lambda Basics | Serverless function deployment | ✅ | [View](./Day-51-lambda)|
| 52 | Lambda + API Gateway | End-to-end serverless API | ✅ | [View](./Day-52-serverless-api) |
| 53 | EventBridge | Event-driven architecture with scheduled triggers | ✅ | [View](./Day-53-eventbridge) |
| 54 | SQS | Queue-based decoupling architecture | ✅ | [View](./Day-54-sqs) |
| 55 | SNS Advanced | Fan-out messaging architecture | ✅ | [View](./Day-55-sns-advanced) |
| 56 | Step Functions | Workflow orchestration with Lambda | ✅ | [View](./Day-56-step-functions) |
| 57 | ECS Basics | Deploy containerized 2048 game application on ECS | ✅ | [View](./Day-57-ecs-basics) |
| 58 | ECS + ALB | Load-balanced containerized application | ✅ | [View](./Day-58-ecs-alb) |
| 59 | ECR | Docker image registry for ECS workloads | ✅ | [View](./Day-59-ecr) |
| 60 | ECS Autoscaling | Automatically scale ECS tasks using CloudWatch metrics | ✅ | [View](./Day-60-ecs-asg) |
| **61** | **ECS EC2 Launch Type** | **Deploy containers on self-managed EC2 instances** | **✅** | **[View](./Day-61-ecs-ec2-launch)** |
---

## 🚀 How to Use

```bash
terraform init
terraform plan
terraform apply
```

**⚠️ Remember to destroy resources after practice to avoid AWS charges.**

```bash
terraform destroy
```

---

## 🗺️ Roadmap (Upcoming)
- **Day 62** = RDS Basics MySQL/Postgres instance
- Focus on reusable, production-grade infrastructure

---

## 👤 Author

**Nikhil Acholiya**

DevOps / Cloud Engineer

Terraform • AWS • Production-grade Infrastructure

---  

## ⭐ Notes

This repository is continuously evolving as part of a long-term infrastructure learning initiative.
