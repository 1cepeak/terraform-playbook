locals {
  MAIN_NODE        = "pve"
  ROOTFS_STORAGE   = "local-lvm"
  OS_TEMPLATE_PATH = "local:vztmpl/almalinux-9-default_20240911_amd64.tar.xz"
  VM_OS_TEMPLATE   = "almalinux9-cloudinit"
  NETWORK_NAME     = "eth0"
  NETWORK_BRIDGE   = "vmbr0"
}

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

variable "SSH_PUBLIC_KEY" {
  type        = string
  description = "SSH public key for the server"
  sensitive   = true
}

variable "VM_USER_NAME" {
  type        = string
  description = "VM user name"
  sensitive   = true
}

variable "VM_USER_PASSWORD" {
  type        = string
  description = "VM user password"
  sensitive   = true
}
