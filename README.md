# cloud-infrastructure

Infrastructure as Code (IaC) templates for provisioning and managing cloud resources on Google Cloud Platform (GCP) using Terraform.

## Structure

```
cloud-infrastructure/
├── gcp/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── compute/
│       │   └── main.tf
│       ├── networking/
│       │   └── main.tf
│       └── firewall/
│           └── main.tf
└── docs/
    └── gcp-setup.md
```

## What This Provisions

| Resource | Description |
|----------|-------------|
| **VPC Network** | Custom VPC with subnet for production workloads |
| **Firewall Rules** | Allow SSH, HTTP, HTTPS, and internal traffic |
| **Compute Instances** | Linux VMs with startup scripts |
| **Static IPs** | Reserved external IPs for stable addressing |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP project with billing enabled
- Service account with Editor role

## Quick Start

```bash
# Authenticate with GCP
gcloud auth application-default login

# Clone the repo
git clone https://github.com/kaloyans/cloud-infrastructure
cd cloud-infrastructure/gcp

# Initialise Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply
```

## Notes

- All resources are tagged for easy identification and cost tracking
- Terraform state should be stored in a GCS bucket for team use
- Variables can be overridden via `terraform.tfvars`
