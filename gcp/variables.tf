# variables.tf — Input variables for GCP infrastructure

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "europe-west3"
}

variable "zone" {
  description = "GCP zone for compute resources"
  type        = string
  default     = "europe-west3-a"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "main-vpc"
}

variable "subnet_cidr" {
  description = "CIDR range for the main subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "machine_type" {
  description = "GCP machine type for compute instances"
  type        = string
  default     = "e2-medium"
}

variable "vm_image" {
  description = "OS image for compute instances"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "ssh_source_ranges" {
  description = "IP ranges allowed to SSH into instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "admin_ip" {
  description = "Admin IP for restricted access"
  type        = string
  default     = "0.0.0.0/0"
}
