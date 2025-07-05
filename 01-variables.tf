variable "SSH_PUBLIC_KEY" {
  type        = string
  description = "SSH public key for the server"
  sensitive   = true
}

locals {
  OS_TEMPLATE_PATH = "local:vztmpl/almalinux-9-default_20240911_amd64.tar.xz"
}
