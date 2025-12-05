# Outputs для модуля VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "nat_gateway_public_ip" {
  value = module.vpc.nat_gateway_public_ip
}

# Outputs для S3 та DynamoDB
output "s3_bucket_name" {
  value = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  value = module.s3_backend.dynamodb_table_name
}

# Outputs для ECR
output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider_url
}

output "jenkins_release" {
  value = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}

output "argo_cd_server_service" {
  description = "Argo CD server service"
  value       = module.argo_cd.argo_cd_server_service
}
