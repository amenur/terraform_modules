<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | List of Availabilities zones for deploy the VPC infrastructure | `list(string)` | n/a | yes |
| <a name="input_create_flow_log_cloudwatch_iam_role"></a> [create\_flow\_log\_cloudwatch\_iam\_role](#input\_create\_flow\_log\_cloudwatch\_iam\_role) | Create the iam role, necessary for the vpc flow log log group | `bool` | `false` | no |
| <a name="input_create_flow_log_cloudwatch_log_group"></a> [create\_flow\_log\_cloudwatch\_log\_group](#input\_create\_flow\_log\_cloudwatch\_log\_group) | Create the flow log, cloudwatch log group | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable/Disable dns hostnames | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable/Disable dns support | `bool` | `true` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | Enable/Disable vpc flow log | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable/Disable the creation of the nat gateways | `bool` | n/a | yes |
| <a name="input_enable_single_nat_gateway"></a> [enable\_single\_nat\_gateway](#input\_enable\_single\_nat\_gateway) | Enable/Disable the creation of one single nat gateway for all az's | `bool` | n/a | yes |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Enable/Disable the VPN Gateway in the VPN | `bool` | n/a | yes |
| <a name="input_flow_log_aggregation_interval"></a> [flow\_log\_aggregation\_interval](#input\_flow\_log\_aggregation\_interval) | Vpc flow log aggregation interval | `number` | `60` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Private subnet tags (for EKS, is necesary to stablish) | `map(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of Private Subnets | `list(string)` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | Profile for deploy the infrastructure | `string` | `"aramis"` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Public subnet tags (for EKS, is necesary to stablish) | `map(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of Public Subnets | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for deploy the infrastructure | `string` | `"eu-west-1"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Cidr Block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Vpc tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones specified as argument to this module |
| <a name="output_name"></a> [name](#output\_name) | The name of the VPC specified as argument to this module |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_private_subnet_tags"></a> [private\_subnet\_tags](#output\_private\_subnet\_tags) | List of VPC Private Subnets Tags |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of Private Subnets IPs |
| <a name="output_public_subnet_tags"></a> [public\_subnet\_tags](#output\_public\_subnet\_tags) | List of VPC Public Subnets Tags |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of Private Subnets IPs |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_tags"></a> [vpc\_tags](#output\_vpc\_tags) | List of VPC Tags |
<!-- END_TF_DOCS -->