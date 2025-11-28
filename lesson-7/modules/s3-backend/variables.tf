variable "bucket_name" {
  description = "Ім'я існуючого S3 бакету для Terraform state"
  type        = string
}

variable "table_name" {
  description = "Ім'я існуючої DynamoDB таблиці для блокування Terraform state"
  type        = string
}
