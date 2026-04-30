# modules/networking/main.tf — VPC and subnet configuration

variable "project_id"  { type = string }
variable "region"      { type = string }
variable "vpc_name"    { type = string }
variable "subnet_cidr" { type = string }
variable "environment" { type = string }

# ── VPC NETWORK ───────────────────────────────────────────────────────────────
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "Main VPC network — ${var.environment}"
}

# ── SUBNET ────────────────────────────────────────────────────────────────────
resource "google_compute_subnetwork" "main" {
  name                     = "${var.vpc_name}-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# ── CLOUD ROUTER (for NAT) ────────────────────────────────────────────────────
resource "google_compute_router" "router" {
  name    = "${var.vpc_name}-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.vpc.id
}

# ── CLOUD NAT ─────────────────────────────────────────────────────────────────
resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc_name}-nat"
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# ── OUTPUTS ───────────────────────────────────────────────────────────────────
output "vpc_name"   { value = google_compute_network.vpc.name }
output "vpc_id"     { value = google_compute_network.vpc.id }
output "subnet_id"  { value = google_compute_subnetwork.main.id }
output "subnet_name" { value = google_compute_subnetwork.main.name }
