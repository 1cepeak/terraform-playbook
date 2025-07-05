resource "proxmox_lxc" "terraform_test" {
  target_node     = "pve"
  hostname        = "terraformtest"
  ostemplate      = local.OS_TEMPLATE_PATH
  unprivileged    = true
  ssh_public_keys = <<-EOT
    ${var.SSH_PUBLIC_KEY}
  EOT
  hastate         = "started"

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = "10G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
    ip6    = "dhcp"
  }
}
