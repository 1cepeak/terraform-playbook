resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_qcow2" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name    = "ubuntu-24.04-noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_download_file" "almalinux_9_6_qcow2" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE
  url          = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  file_name    = "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
}
