
## Esto nos permite establecer una encriptación KMS en el bucket donde almacenaremos el .tfstate
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = var.billing_mode
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}