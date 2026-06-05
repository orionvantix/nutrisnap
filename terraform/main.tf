terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
  required_version = ">= 1.3.0"
}

provider "hcloud" {
  token = var.hcloud_token
}

# SSH key for server access
resource "hcloud_ssh_key" "nutrisnap" {
  name       = "nutrisnap-key"
  public_key = var.ssh_public_key
}

# VPS server
resource "hcloud_server" "nutrisnap" {
  name        = "nutrisnap-vps"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.nutrisnap.id]

  labels = {
    app = "nutrisnap"
    env = var.environment
  }

  user_data = templatefile("${path.module}/scripts/init.sh", {
    openai_api_key   = var.openai_api_key
    nutrisnap_secret = var.nutrisnap_secret
    domain           = var.domain
  })
}

# Firewall rules
resource "hcloud_firewall" "nutrisnap" {
  name = "nutrisnap-firewall"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_firewall_attachment" "nutrisnap" {
  firewall_id = hcloud_firewall.nutrisnap.id
  server_ids  = [hcloud_server.nutrisnap.id]
}
