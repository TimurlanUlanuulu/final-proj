# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Terraform IaC project provisioning AWS infrastructure — specifically EKS (Elastic Kubernetes Service) and VPC resources.

## Common Terraform Commands

```bash
terraform init          # Initialize providers and modules
terraform validate      # Check syntax/configuration validity
terraform fmt           # Format .tf files
terraform plan -var-file=env/dev.tfvars   # Preview changes for dev
terraform apply -var-file=env/dev.tfvars  # Apply changes for dev
terraform destroy -var-file=env/dev.tfvars
```

## Architecture

```
main.tf          # Root module — wires VPC and EKS modules together
providers.tf     # AWS provider configuration
variables.tf     # Input variable declarations
outputs.tf       # Root-level output values
env/dev.tfvars   # Development environment variable values
modules/vpc/     # VPC, subnets, routing, NAT gateway
modules/eks/     # EKS cluster, node groups, IAM roles
```

The root module calls `modules/vpc` first to create networking, then passes VPC/subnet IDs into `modules/eks`. Each module should have its own `main.tf`, `variables.tf`, and `outputs.tf`.

## Branch Strategy

- `main` — stable/reviewed infrastructure
- `feature/eks` — current active branch for EKS implementation

## Notes

- `*.tfvars` files are gitignored — never commit secrets or account-specific values
- Terraform state files are gitignored; a remote backend (S3 + DynamoDB) should be configured in `providers.tf`
