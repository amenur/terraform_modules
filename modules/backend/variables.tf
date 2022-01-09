
variable "s3_bucket_name" {
  type = string
  description = "(required) Unique identifier bucket name"
}

variable "sse_algorithm" {
  type = string
  description = "(optional) Encryption Algorithm"
  default = "AES256"
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

