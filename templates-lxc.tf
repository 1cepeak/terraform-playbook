resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_vztmpl" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.PROXMOX_NODE
  url          = "http://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}

