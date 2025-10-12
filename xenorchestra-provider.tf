# Instruct terraform to download the provider on `terraform init`
terraform {
  required_providers {
    xenorchestra = {
      source = "vatesfr/xenorchestra"
    }
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  insecure = true
}
