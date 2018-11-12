terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "maburix-demo-terraform-state"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
    key            = "prod_remote_state"
  }
}
