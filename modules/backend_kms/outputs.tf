
output "s3_bucket_id" {
  value = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_id" {
  value = aws_dynamodb_table.terraform_state.id
}

output "dynamodb_table_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "kms_key_id" {
  value = aws_kms_key.kms_key.id
}

output "kms_key_arn" {
  value = aws_kms_key.kms_key.arn
}

