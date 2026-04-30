# modules/firewall/main.tf — Firewall rules for GCP VPC

variable "project_id"        { type = string }
variable "vpc_name"          { type = string }
variable "ssh_source_ranges" { type = list(string) }
variable "environment"       { type = string }

# ── ALLOW SSH ─────────────────────────────────────────────────────────────────
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  project = var.project_id
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_source_ranges
  target_tags   = ["ssh-allowed"]
  description   = "Allow SSH access — ${var.environment}"
}

# ── ALLOW HTTP / HTTPS ────────────────────────────────────────────────────────
resource "google_compute_firewall" "allow_web" {
  name    = "${var.vpc_name}-allow-web"
  project = var.project_id
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
  description   = "Allow HTTP and HTTPS traffic"
}

# ── ALLOW INTERNAL TRAFFIC ────────────────────────────────────────────────────
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  project = var.project_id
  network = var.vpc_name

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.1.0/24"]
  description   = "Allow all internal traffic within subnet"
}

# ── ALLOW MONITORING ──────────────────────────────────────────────────────────
resource "google_compute_firewall" "allow_monitoring" {
  name    = "${var.vpc_name}-allow-monitoring"
  project = var.project_id
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["9090", "9093", "3000", "9100"]
  }

  source_ranges = ["10.0.1.0/24"]
  target_tags   = ["monitoring"]
  description   = "Allow Prometheus, Grafana, Alertmanager — internal only"
}

# ── DENY ALL INGRESS (explicit) ───────────────────────────────────────────────
resource "google_compute_firewall" "deny_all_ingress" {
  name      = "${var.vpc_name}-deny-all-ingress"
  project   = var.project_id
  network   = var.vpc_name
  priority  = 65534

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  description   = "Deny all other ingress traffic"
}
