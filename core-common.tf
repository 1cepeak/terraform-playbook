resource "tls_private_key" "core_container" {
  algorithm = "ED25519"
}

resource "local_file" "core_private_key_local" {
  filename = pathexpand("~/.ssh/core")
  content  = <<-EOF
    ${tls_private_key.core_container.private_key_openssh}
  EOF
}

resource "local_file" "core_public_key_local" {
  filename = pathexpand("~/.ssh/core.pub")
  content  = <<-EOF
    ${tls_private_key.core_container.public_key_openssh}
  EOF
}
