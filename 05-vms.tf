# resource "proxmox_vm_qemu" "vm_example" {
#   name             = "vm-example"
#   target_node      = local.MAIN_NODE
#   agent            = 1
#   memory           = 2048
#   clone            = local.VM_OS_TEMPLATE
#   scsihw           = "virtio-scsi-single"
#   hastate          = "started"
#   automatic_reboot = true

#   ipconfig0  = "ip=192.168.3.70/24,gw=192.168.3.1,ip6=dhcp"
#   ciuser     = var.VM_USER_NAME
#   cipassword = var.VM_USER_PASSWORD
#   sshkeys    = var.SSH_PUBLIC_KEY

#   cpu {
#     cores = 4
#     sockets = 1
#   }
# }
