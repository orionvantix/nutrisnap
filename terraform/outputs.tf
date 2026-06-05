output "server_ip" {
  description = "Public IP address of the NutriSnap VPS"
  value       = hcloud_server.nutrisnap.ipv4_address
}

output "server_id" {
  description = "Hetzner server ID"
  value       = hcloud_server.nutrisnap.id
}

output "app_url" {
  description = "Live app URL"
  value       = "https://${var.domain}/nutrisnap.html"
}
