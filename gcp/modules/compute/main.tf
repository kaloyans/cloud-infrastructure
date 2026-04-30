# modules/compute/main.tf — GCP Compute instances

variable "project_id"   { type = string }
variable "zone"         { type = string }
variable "machine_type" { type = string }
variable "vm_image"     { type = string }
variable "subnet_id"    { type = string }
variable "environment"  { type = string }

# ── STATIC EXTERNAL IPs ───────────────────────────────────────────────────────
resource "google_compute_address" "web_ip" {
  name    = "web-server-ip"
  project = var.project_id
  region  = substr(var.zone, 0, length(var.zone) - 2)
}

resource "google_compute_address" "monitoring_ip" {
  name    = "monitoring-server-ip"
  project = var.project_id
  region  = substr(var.zone, 0, length(var.zone) - 2)
}

# ── WEB SERVER ────────────────────────────────────────────────────────────────
resource "google_compute_instance" "web_server" {
  name         = "web-server"
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type

  tags = ["ssh-allowed", "web-server"]

  labels = {
    environment = var.environment
    role        = "web"
  }

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = 20
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {
      nat_ip = google_compute_address.web_ip.address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx curl wget git
    systemctl enable nginx
    systemctl start nginx
  EOF

  metadata = {
    enable-oslogin = "TRUE"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

# ── MONITORING SERVER ─────────────────────────────────────────────────────────
resource "google_compute_instance" "monitoring_server" {
  name         = "monitoring-server"
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type

  tags = ["ssh-allowed", "monitoring"]

  labels = {
    environment = var.environment
    role        = "monitoring"
  }

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = 40
      type  = "pd-ssd"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {
      nat_ip = google_compute_address.monitoring_ip.address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose-v2 curl
    systemctl enable docker
    systemctl start docker
  EOF

  metadata = {
    enable-oslogin = "TRUE"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}

# ── OUTPUTS ───────────────────────────────────────────────────────────────────
output "web_server_external_ip" {
  value = google_compute_address.web_ip.address
}

output "monitoring_server_external_ip" {
  value = google_compute_address.monitoring_ip.address
}
