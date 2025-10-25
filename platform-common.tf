resource "tls_private_key" "platform" {
  algorithm = "ED25519"
}

resource "local_file" "platform_private_key" {
  filename = pathexpand("~/.ssh/platform")
  content  = <<-EOF
    ${tls_private_key.platform.private_key_openssh}
  EOF
}

resource "local_file" "platform_public_key" {
  filename = pathexpand("~/.ssh/platform.pub")
  content  = <<-EOF
    ${tls_private_key.platform.public_key_openssh}
  EOF
}
