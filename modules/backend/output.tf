
output "s3_bucket_id" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamo_table_id" {
  value = aws_dynamodb_table.terraform_state.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "dynamo_table_arn" {
  value = aws_dynamodb_table.terraform_state.arn
}

output "encryption_algorithm" {
  value = aws_s3_bucket.terraform_state.server_side_encryption_configuration.sse_algorithm
}