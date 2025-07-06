variable "PM_API_TOKEN_ID" {
  type        = string
  description = "Proxmox API token ID"
  sensitive   = true
}

variable "PM_API_TOKEN_SECRET" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "S3_ACCESS_KEY" {
  type        = string
  description = "S3 access key"
}

variable "S3_SECRET_KEY" {
  type        = string
  description = "S3 secret key"
}

variable "SSH_PUBLIC_KEY" {
  type        = string
  description = "SSH public key for the server"
  sensitive   = true
}
