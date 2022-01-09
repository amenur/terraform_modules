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
| [aws_dynamodb_table.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_kms_alias.key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deletion_windows_day"></a> [deletion\_windows\_day](#input\_deletion\_windows\_day) | (optional) Deletion windows for rotate the KMS Keys | `number` | `10` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | (required) DynamoDB Table name for lock the tfstate | `string` | n/a | yes |
| <a name="input_key_alias"></a> [key\_alias](#input\_key\_alias) | (required) Alias for the KMS Key | `string` | n/a | yes |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | (optional) Enable (true) / Disable(false), the rotation of the key. Default = 'Enable' (true) | `bool` | `true` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | (optional) max capacity of simultaneously read requests | `number` | `1` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | (required) Unique identifier bucket name | `string` | n/a | yes |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | (optional) max capacity of simultaneosly write requests | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table_arn"></a> [dynamodb\_table\_arn](#output\_dynamodb\_table\_arn) | n/a |
| <a name="output_dynamodb_table_id"></a> [dynamodb\_table\_id](#output\_dynamodb\_table\_id) | n/a |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | n/a |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | n/a |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | n/a |
<!-- END_TF_DOCS -->