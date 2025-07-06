terraform {
  backend "s3" {
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    endpoints                   = {
      s3 = "http://77.37.140.142:7480"
    }
    region                      = "eu-ru"
    bucket                      = "terraform"
    key                         = "state/terraform.tfstate"
    encrypt                     = true
    use_path_style              = true
  }
}
