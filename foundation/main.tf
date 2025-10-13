resource "random_password" "minio_container" {
  length = 20
  special = false
}

resource "random_password" "minio_admin" {
  length = 20
  special = false
}

resource "tls_private_key" "minio_container" {
  algorithm = "ED25519"
}
