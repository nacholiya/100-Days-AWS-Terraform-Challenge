# Day 20 – Enable HTTPS on ALB using ACM with Terraform

## What This Builds
This module provisions an AWS Certificate Manager (ACM) certificate
and attaches it to an Application Load Balancer (ALB) to enable HTTPS
for secure encrypted communication.

## AWS Services Used
- AWS Certificate Manager (ACM)
- Application Load Balancer (ALB)
- Amazon Route 53 (for DNS validation)

## Resources Created
- ACM Certificate
- DNS Validation Record
- HTTPS Listener (Port 443)
- ALB Listener Rule (optional redirect HTTP → HTTPS)

## Architecture
User Request (HTTPS) → Route 53 Domain → ACM Certificate (TLS) → ALB HTTPS Listener (443) → Target Groups → EC2 Instances

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify

- Confirm ACM certificate is issued
- Open: ```https://<your-domain-name>```
- Verify secure lock icon in browser
- Confirm HTTP automatically redirects to HTTPS

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- Difference between HTTP and HTTPS
- Enforcing secure communication