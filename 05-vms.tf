resource "proxmox_vm_qemu" "vm_example" {
  name             = "vm-example"
  target_node      = local.MAIN_NODE
  agent            = 1
  cores            = 2
  memory           = 1024
  boot             = "order=scsi0"
  clone            = local.VM_OS_TEMPLATE
  scsihw           = "virtio-scsi-single"
  hastate          = "started"
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom = "vendor=local:snippets/qemu-guest-agent.yml"
  # nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=192.168.3.70/24,gw=192.168.3.1,ip6=dhcp"
  ciuser     = var.VM_USER_NAME
  cipassword = var.VM_USER_PASSWORD
  sshkeys    = var.SSH_PUBLIC_KEY

  disks {
    scsi {
      scsi0 {
        disk {
          storage = local.ROOTFS_STORAGE
          size    = "2G"
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = local.ROOTFS_STORAGE
        }
      }
    }
  }

  network {
    id     = 0
    bridge = local.NETWORK_BRIDGE
    model  = "virtio"
  }
}
