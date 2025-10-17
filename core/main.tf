# Common

resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_vztmpl" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE
  url          = "http://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

resource "tls_private_key" "core_container" {
  algorithm = "ED25519"
}

# MinIO

resource "random_password" "minio_container" {
  length  = 20
  special = false
}

resource "random_password" "minio_admin" {
  length  = 20
  special = false
}

resource "proxmox_virtual_environment_container" "minio" {
  node_name     = var.PROXMOX_NODE
  vm_id         = 101
  tags          = ["core"]
  start_on_boot = true
  unprivileged  = true

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
  }

  mount_point {
    volume = "local-lvm"
    path   = "/data"
    size   = "100G"
    backup = true
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.ubuntu_24_04_vztmpl.id
    type             = "ubuntu"
  }

  initialization {
    hostname = "minio"

    ip_config {
      ipv4 {
        address = "192.168.3.100/24"
        gateway = "192.168.3.1"
      }
    }

    user_account {
      keys     = [trimspace(tls_private_key.core_container.public_key_openssh)]
      password = random_password.minio_container.result
    }
  }

  connection {
    agent       = false
    type        = "ssh"
    user        = "root"
    private_key = trimspace(tls_private_key.core_container.private_key_openssh)
    host        = "192.168.3.100"
  }

  provisioner "file" {
    destination = "/root/config.envrc"
    content     = <<-EOF
    export MINIO_ROOT_USER='${var.MINIO_USER}'
    export MINIO_ROOT_PASSWORD='${random_password.minio_admin.result}'
    export MINIO_DATA_DIR='${self.mount_point[0].path}'
    export MINIO_DEFAULT_BUCKETS='${join(" ", var.MINIO_BUCKETS)}'
    EOF
  }

  provisioner "file" {
    destination = "/root/install_minio.sh"
    source      = "scripts/install_minio.sh"
  }

  provisioner "remote-exec" {
    inline = ["sh /root/install_minio.sh"]
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Nginx

resource "random_password" "nginx_container" {
  length  = 20
  special = false
}

resource "proxmox_virtual_environment_container" "nginx" {
  node_name     = var.PROXMOX_NODE
  vm_id         = 102
  tags          = ["core"]
  start_on_boot = true
  unprivileged  = true

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 20
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.ubuntu_24_04_vztmpl.id
    type             = "ubuntu"
  }

  initialization {
    hostname = "nginx"

    ip_config {
      ipv4 {
        address = "192.168.3.101/24"
        gateway = "192.168.3.1"
      }
    }

    user_account {
      keys     = [trimspace(tls_private_key.core_container.public_key_openssh)]
      password = random_password.nginx_container.result
    }
  }

  connection {
    agent       = false
    type        = "ssh"
    user        = "root"
    private_key = trimspace(tls_private_key.core_container.private_key_openssh)
    host        = "192.168.3.101"
  }

  provisioner "file" {
    destination = "/root/install_nginx.sh"
    source      = "scripts/install_nginx.sh"
  }

  provisioner "remote-exec" {
    inline = ["sh /root/install_nginx.sh"]
  }

  lifecycle {
    prevent_destroy = true
  }
}
