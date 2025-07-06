terraform {
  backend "s3" {
    endpoint                    = "http://77.37.140.142:7480"
    bucket                      = "terraform"
    key                         = "state/terraform.tfstate"
    encrypt                     = true
    access_key                  = var.S3_ACCESS_KEY
    secret_key                  = var.S3_SECRET_KEY
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
