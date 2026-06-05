variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for server access"
  type        = string
}

variable "openai_api_key" {
  description = "OpenAI API key for GPT-4o Vision"
  type        = string
  sensitive   = true
}

variable "nutrisnap_secret" {
  description = "Secret key for NutriSnap proxy authentication"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Domain name for the app"
  type        = string
  default     = "nutrisnap.example.com"
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cx22"
}

variable "location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "nbg1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}
