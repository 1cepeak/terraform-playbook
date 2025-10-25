locals {
  user        = "nexus"
  group       = "nexus"
  install_dir = "/opt/sonatype"
}

resource "random_password" "nexus_vm_password" {
  length  = 20
  special = false
}

resource "random_password" "nexus_user_password" {
  length  = 20
  special = false
}

resource "proxmox_virtual_environment_file" "nexus_cfg" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE

  source_raw {
    file_name = "nexus.cloud-config.yaml"
    data      = <<-EOL
      #cloud-config
      hostname: nexus
      password: ${random_password.nexus_vm_password.result}
      chpasswd:
        expire: false
      groups:
        - ${local.group}
      users:
        - default
        - name: ${local.user}
          system: true
          shell: /usr/bin/nologin
          primary_group: ${local.group}
      ssh_pwauth: true
      ssh_authorized_keys:
        - ${tls_private_key.platform.public_key_openssh}
      package_update: true
      package_upgrade: true
      packages:
        - qemu-guest-agent
        - wget
      write_files:
        - path: /etc/systemd/system/nexus.service
          owner: 'root:root'
          permissions: '0600'
          content: |
            [Unit]
            Description=Sonatype Nexus Service
            After=network.target

            [Service]
            Type=forking
            LimitNOFILE=65536
            ExecStart=${local.install_dir}/nexus/bin/nexus run
            ExecStop=${local.install_dir}/nexus/bin/nexus stop

            User=nexus
            Restart=on-abort
            TimeoutSec=600

            [Install]
            WantedBy=multi-user.target
      runcmd:
        - systemctl enable --now qemu-guest-agent
        - mkdir ${local.install_dir}
        - wget https://download.sonatype.com/nexus/3/nexus-3.85.0-03-linux-x86_64.tar.gz
        - tar xvz --keep-directory-symlink -f ./nexus-3.85.0-03-linux-x86_64.tar.gz
        - mv nexus-3.85.0-03 ${local.install_dir}/nexus
        - mv sonatype-work ${local.install_dir}/sonatype-work
        - echo 'run_as_user="${local.user}"' >> ${local.install_dir}/nexus/bin/nexus.rc
        - chmod +x ${local.install_dir}/nexus/bin/nexus
        - chown -R ${local.user}:${local.group} ${local.install_dir}
        - sudo systemctl daemon-reload
        - sudo systemctl enable nexus.service
        - sudo systemctl start nexus.service
    EOL
  }
}

resource "proxmox_virtual_environment_vm" "nexus" {
  name      = "nexus"
  node_name = var.PROXMOX_NODE
  vm_id     = 201
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
    file_id      = proxmox_virtual_environment_download_file.ubuntu_24_04_qcow2.id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.3.110/24"
        gateway = "192.168.3.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.nexus_cfg.id
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}
