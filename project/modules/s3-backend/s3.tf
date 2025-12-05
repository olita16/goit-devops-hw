# Підключення до існуючого S3 бакету
data "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
}


