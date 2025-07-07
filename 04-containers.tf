# resource "proxmox_lxc" "example-container" {
#   hostname     = "example-container"
#   start        = true
#   unprivileged = true

#   target_node     = local.MAIN_NODE
#   ostemplate      = local.LXC_OS_TEMPLATE_PATH
#   ssh_public_keys = <<-EOT
#     ${var.SSH_PUBLIC_KEY}
#   EOT

#   rootfs {
#     storage = local.ROOTFS_STORAGE
#     size    = "2G"
#   }

#   network {
#     name   = local.NETWORK_NAME
#     bridge = local.NETWORK_BRIDGE
#     ip     = local.NETWORK_IP
#     ip6    = local.NETWORK_IP6
#   }
# }
