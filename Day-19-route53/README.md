# Day 19 – Route 53 Hosted Zone & ALB Alias with Terraform

## What This Builds
This module provisions a Route 53 hosted zone and creates an alias record
that maps a domain name to an Application Load Balancer (ALB).

## AWS Services Used
- Amazon Route 53
- Application Load Balancer (ALB)

## Resources Created
- Route 53 Hosted Zone
- A Record (Alias)
- ALB DNS Target Mapping

## Architecture
User Request  
→ Domain Name (your domain)  
→ Route 53 Hosted Zone  
→ Alias Record  
→ Application Load Balancer  
→ Target Groups  
→ EC2 Instances

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## How to Verify

- Get ALB DNS
- Configure the domanin name in Route 53
- Access application using: ```http://<your daomain name>```
- Confirm traffic routes to ALB

## How to Clean Up

```bash
terraform destroy
```

## Key Learnings

- What is hosted zone
- How DNS routing works in AWS
- Connecting infrastructur with real world domain names