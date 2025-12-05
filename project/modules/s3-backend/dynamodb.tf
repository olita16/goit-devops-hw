# Підключення до існуючої DynamoDB таблиці
data "aws_dynamodb_table" "terraform_locks" {
  name = var.table_name
}
