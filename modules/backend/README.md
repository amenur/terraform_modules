<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform_locks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | (required) DynamoDB Table name for lock the tfstate | `string` | n/a | yes |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | (optional) max capacity of simultaneously read requests | `number` | `1` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | (required) Unique identifier bucket name | `string` | n/a | yes |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | (optional) Encryption Algorithm | `string` | `"AES256"` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | (optional) max capacity of simultaneosly write requests | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamo_table_arn"></a> [dynamo\_table\_arn](#output\_dynamo\_table\_arn) | n/a |
| <a name="output_dynamo_table_id"></a> [dynamo\_table\_id](#output\_dynamo\_table\_id) | n/a |
| <a name="output_encryption_algorithm"></a> [encryption\_algorithm](#output\_encryption\_algorithm) | n/a |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | n/a |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | n/a |
<!-- END_TF_DOCS -->