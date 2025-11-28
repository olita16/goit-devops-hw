output "s3_bucket_name" {
  value = data.aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = data.aws_dynamodb_table.terraform_locks.name
}
