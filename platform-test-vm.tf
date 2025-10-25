resource "random_password" "test_vm_password" {
  length  = 20
  special = false
}

resource "proxmox_virtual_environment_file" "test_vm_cfg" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE

  source_raw {
    file_name = "test-vm.cloud-config.yaml"
    data = templatefile("templates/almalinux.cloud-config.tfpl", {
      hostname       = "test"
      password       = random_password.test_vm_password.result
      ssh_public_key = tls_private_key.platform.public_key_openssh
    })
  }
}

resource "proxmox_virtual_environment_vm" "test_vm" {
  name      = "test"
  node_name = var.PROXMOX_NODE
  vm_id     = 202
  tags      = ["platform"]

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
    floating  = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    size         = 20
    file_id      = proxmox_virtual_environment_download_file.almalinux_9_6_qcow2.id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.3.111/24"
        gateway = "192.168.3.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.test_vm_cfg.id
  }

  #lifecycle {
  #  prevent_destroy = true
  #}
}
