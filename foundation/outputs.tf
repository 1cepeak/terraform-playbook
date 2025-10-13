output "MINIO_CONTAINER_PASSWORD" {
  value = random_password.minio_container.result
  sensitive = true
}

output "MINIO_ADMIN_PASSWORD" {
  value = random_password.minio_admin.result
  sensitive = true
}
