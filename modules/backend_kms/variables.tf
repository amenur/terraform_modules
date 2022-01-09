
variable "enable_key_rotation" {
    type = bool
    description = "(optional) Enable (true) / Disable(false), the rotation of the key. Default = 'Enable' (true)"
    #default = true
}

variable "deletion_windows_day" {
    type = number
    description = "(optional) Deletion windows for rotate the KMS Keys"
    default = 10
}

variable "key_alias" {
    type = string
    description = "(required) Alias for the KMS Key"
}

variable "s3_bucket_name" {
  type = string
  description = "(required) Unique identifier bucket name"
}

variable "dynamodb_table_name" {
  type = string
  description = "(required) DynamoDB Table name for lock the tfstate"
}

variable "read_capacity" {
  type = number
  description = "(optional) max capacity of simultaneously read requests"
  default = 1
}

variable "write_capacity" {
  type = number
  description = "(optional) max capacity of simultaneosly write requests"
  default = 1
}

