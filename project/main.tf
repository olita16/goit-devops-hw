provider "aws" {
  region = "eu-central-1"
}


# Доступ до кластера EKS

#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.eks.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#  token                  = data.aws_eks_cluster_auth.eks.token
#}

#provider "helm" {
#  kubernetes {
#    host                   = data.aws_eks_cluster.eks.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#    token                  = data.aws_eks_cluster_auth.eks.token
#  }
#}

#data "aws_eks_cluster" "eks" {
#  name = module.eks.eks_cluster_name
#}

#data "aws_eks_cluster_auth" "eks" {
#  name = module.eks.eks_cluster_name
#}


# Модулі

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "lesson-7-terraform-state-826232761489"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-7-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-ecr"
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "eks-cluster-demo"
  subnet_ids = module.vpc.private_subnets
  instance_type = "t3.small"
  desired_size  = 3
  max_size      = 3
  min_size      = 2
}


#Модуль Jenkins
#module "jenkins" {
#  source                 = "./modules/jenkins"
#  cluster_name           = module.eks.eks_cluster_name
#  jenkins_admin_password = var.jenkins_admin_password
#  github_username        = var.github_username
#  github_pat             = var.github_pat
#  github_url             = var.github_url
#  github_main_branch     = var.github_main_branch
#  oidc_provider_arn      = module.eks.oidc_provider_arn
#  oidc_provider_url      = module.eks.oidc_provider_url


#  providers = {
#    kubernetes = kubernetes
#    helm       = helm
#  }
#}


#Підключаємо модуль Argo CD
#module "argo_cd" {
#  source       = "./modules/argo_cd"
#  namespace    = "argocd"
#  chart_version = "5.46.4"
#  github_username = var.github_username
#  github_pat = var.github_pat
#  github_url = var.github_tf_url
#  github_main_branch = var.github_tf_branch
#  helm_chart_path = var.helm_chart_path
#}

#Підключаємо модуль RDS
#module "rds" {
#  source = "./modules/rds"

#  name                       = "myapp-db"
#  use_aurora                 = false

  # --- Aurora-only ---
#  engine_cluster             = "aurora-postgresql"
#  engine_version_cluster     = "15.3"
#  parameter_group_family_aurora = "aurora-postgresql15"
#  aurora_replica_count       = 2

  # --- RDS-only ---
#  engine                     = "postgres"
#  engine_version             = "17.2"
#  parameter_group_family_rds = "postgres17"

  # Common
#  instance_class             = "db.t3.micro"
#  allocated_storage          = 20
#  db_name                    = "myapp"
#  username                   = "postgres"
#  password                   = "admin123AWS23"
#  subnet_private_ids         = module.vpc.private_subnets
#  subnet_public_ids          = module.vpc.public_subnets
#  publicly_accessible        = true
#  vpc_id                     = module.vpc.vpc_id
#  multi_az                   = true
#  backup_retention_period    = 1
#  parameters = {
#    max_connections              = "200"
#    log_min_duration_statement   = "500"
#  }

#  tags = {
#    Environment = "dev"
#    Project     = "myapp"
#  }
#}


# Створюємо Kubernetes Secret з даними RDS
# resource "kubernetes_secret" "rds_credentials" {
#   metadata {
#     name      = "rds-credentials"
#     namespace = "default"
#   }

#   data = {
#     POSTGRES_HOST     = module.rds.db_host
#     POSTGRES_PORT     = tostring(module.rds.db_port)
#     POSTGRES_DB       = module.rds.db_name
#     POSTGRES_USER     = module.rds.db_username
#     POSTGRES_PASSWORD = module.rds.db_password
#   }

#   type = "Opaque"

#   depends_on = [module.eks, module.rds]
# }

#Підключаємо модуль Prometheus
#module "prometheus" {
#   source        = "./modules/prometheus"
#   namespace     = "prometheus"
#   chart_version = "25.8.0"
#   providers = {
#     helm = helm
#   }
# }

#Підключаємо модуль Grafana
# module "grafana" {
#   source       = "./modules/grafana"
#   namespace    = "grafana"
#   chart_version = "7.0.0"
#  grafana_admin_password = var.grafana_admin_password
#   prometheus_url = module.prometheus.prometheus_server_url
#   providers = {
#     helm = helm
#   }
#   depends_on = [module.prometheus]
# }