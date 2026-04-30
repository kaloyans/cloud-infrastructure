# outputs.tf — Output values after terraform apply

output "vpc_name" {
  description = "Name of the created VPC network"
  value       = module.networking.vpc_name
}

output "subnet_name" {
  description = "Name of the created subnet"
  value       = module.networking.subnet_name
}

output "subnet_cidr" {
  description = "CIDR range of the subnet"
  value       = var.subnet_cidr
}

output "web_server_external_ip" {
  description = "External IP of the web server"
  value       = module.compute.web_server_external_ip
}

output "monitoring_server_external_ip" {
  description = "External IP of the monitoring server"
  value       = module.compute.monitoring_server_external_ip
}

output "ssh_connection_web" {
  description = "SSH command to connect to web server"
  value       = "gcloud compute ssh web-server --zone=${var.zone} --project=${var.project_id}"
}

output "ssh_connection_monitoring" {
  description = "SSH command to connect to monitoring server"
  value       = "gcloud compute ssh monitoring-server --zone=${var.zone} --project=${var.project_id}"
}
