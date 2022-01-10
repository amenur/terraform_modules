resource "aws_kms_key" "kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.deletion_windows_day
  enable_key_rotation     = var.enable_key_rotation
}

resource "aws_kms_alias" "key_alias" {
  name          = var.key_alias
  target_key_id = aws_kms_key.kms_key.id
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = var.s3_bucket_name
    target_prefix = var.log_prefix
  }
  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state" {
  name           = var.dynamodb_table_name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockID"

  server_side_encryption {
    enabled     = var.dynamodb_encryption
    kms_key_arn = aws_kms_key.kms_key.arn
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  depends_on = [
    aws_kms_key.kms_key,
  ]
}