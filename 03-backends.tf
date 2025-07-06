terraform {
  backend "s3" {
    endpoint                    = "http://77.37.140.142:7480"
    region                      = "eu-east-1"
    bucket                      = "terraform"
    key                         = "state/terraform.tfstate"
    encrypt                     = true
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
