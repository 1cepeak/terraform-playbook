locals {
  MAIN_NODE        = "pve"
  OS_TEMPLATE_PATH = "local:vztmpl/almalinux-9-default_20240911_amd64.tar.xz"
  ROOTFS_STORAGE   = "local-lvm"
  NETWORK_NAME     = "eth0"
  NETWORK_BRIDGE   = "vmbr0"
  NETWORK_IP       = "dhcp"
  NETWORK_IP6      = "dhcp"
}

resource "proxmox_lxc" "terraform_test" {
  hostname        = "terraformtest"
  hastate         = "started"
  unprivileged    = true

  target_node     = local.MAIN_NODE
  ostemplate      = local.OS_TEMPLATE_PATH
  ssh_public_keys = <<-EOT
    ${var.SSH_PUBLIC_KEY}
  EOT

  rootfs {
    size    = "2G"
    storage = local.ROOTFS_STORAGE
  }

  network {
    name   = local.NETWORK_NAME
    bridge = local.NETWORK_BRIDGE
    ip     = local.NETWORK_IP
    ip6    = local.NETWORK_IP6
  }
}
