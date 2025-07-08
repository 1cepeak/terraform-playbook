resource "proxmox_lxc" "example-container" {
  hostname     = "example-container"
  start        = true
  unprivileged = true

  target_node     = local.MAIN_NODE
  ostemplate      = local.OS_TEMPLATE_PATH
  ssh_public_keys = <<-EOT
    ${var.SSH_PUBLIC_KEY}
  EOT

  rootfs {
    storage = local.ROOTFS_STORAGE
    size    = "20G"
  }

  network {
    name   = local.NETWORK_NAME
    bridge = local.NETWORK_BRIDGE
    ip     = "192.168.3.70/24"
  }
}
