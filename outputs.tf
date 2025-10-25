output "CORE_CONTAINER_PRIVATE_KEY" {
  value     = tls_private_key.core_container.private_key_openssh
  sensitive = true
}

output "MINIO_CONTAINER_PASSWORD" {
  value     = random_password.minio_container.result
  sensitive = true
}

output "MINIO_ADMIN_PASSWORD" {
  value     = random_password.minio_admin.result
  sensitive = true
}

output "NGINX_CONTAINER_PASSWORD" {
  value     = random_password.nginx_container.result
  sensitive = true
}

output "NEXUS_VM_PASSWORD" {
  value     = random_password.nexus_vm_password.result
  sensitive = true
}

output "NEXUS_USER_PASSWORD" {
  value     = random_password.nexus_user_password.result
  sensitive = true
}

output "TEST_VM_PASSWORD" {
  value     = random_password.test_vm_password.result
  sensitive = true
}
