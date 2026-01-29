# Day 03 – Amazon DynamoDB with Terraform

## What This Builds
This module provisions an Amazon DynamoDB table using Terraform with on-demand billing mode
and a partition key for scalable, serverless data storage.

## AWS Services Used
- Amazon DynamoDB

## Resources Created
- DynamoDB Table

## Architecture
Terraform → DynamoDB → Key-Value Storage

## How to Deploy
terraform init
terraform plan
terraform apply

## How to Clean Up
terraform destroy

## Key Learnings
- Partition key importance
- PAY_PER_REQUEST vs provisioned billing
- When to use DynamoDB over RDS
