# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "terraform-state-bucket"
# }

# resource "aws_dynamodb_table" "terraform_state_lock" {
#   name = "terraform-state-lock"
#   hash_key = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#   server_side_encryption {
#     enabled = true
#   }
#   lifecycle {
# }
