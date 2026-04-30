# main.tf — Root module for GCP infrastructure

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  # Uncomment to store state in GCS bucket
  # backend "gcs" {
  #   bucket = "your-terraform-state-bucket"
  #   prefix = "terraform/state"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# ── NETWORKING ────────────────────────────────────────────────────────────────
module "networking" {
  source      = "./modules/networking"
  project_id  = var.project_id
  region      = var.region
  vpc_name    = var.vpc_name
  subnet_cidr = var.subnet_cidr
  environment = var.environment
}

# ── FIREWALL ──────────────────────────────────────────────────────────────────
module "firewall" {
  source            = "./modules/firewall"
  project_id        = var.project_id
  vpc_name          = module.networking.vpc_name
  ssh_source_ranges = var.ssh_source_ranges
  environment       = var.environment
}

# ── COMPUTE ───────────────────────────────────────────────────────────────────
module "compute" {
  source       = "./modules/compute"
  project_id   = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  vm_image     = var.vm_image
  subnet_id    = module.networking.subnet_id
  environment  = var.environment
}
