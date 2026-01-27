# 🚀 100 Days of Terraform with AWS

> A hands-on, production-focused Terraform + AWS challenge with daily infrastructure builds and clean teardown.


**Progress:** Day 9 / 100 🚀 &nbsp;
![Terraform](https://img.shields.io/badge/Terraform-IaC-purple)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Status](https://img.shields.io/badge/Consistency-Daily%20Push-success)

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
> 
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
| **09** | **EC2 Launch Templates** | **Versioned EC2 launch configs, immutable updates** | ✅ | [View](./Day-09-ec2-lt/) |


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
- **Day 10** — EC2 User Data & Bootstrapping (Zero-touch servers)
- Focus on reusable, production-grade infrastructure

---

## 👤 Author

**Nikhil Acholiya**

DevOps / Cloud Engineer

Terraform • AWS • Production-grade Infrastructure

---  

## ⭐ Notes

This repository is continuously evolving as part of a long-term infrastructure learning initiative.
