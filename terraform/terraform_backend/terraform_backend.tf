provider "aws" {
  region = "${ var.region }"
}

#S3 terraform backend
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "${ var.bucket_name }"
  acl    = "private"
  versioning {
      enabled = true
  }

  lifecycle {
      prevent_destroy = true
  }

  tags {
    Name        = "terraform"
    Environment = "prod"
  }
}


# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {

  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Name = "Terraform State Lock Table"
  }
}
