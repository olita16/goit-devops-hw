provider "aws" {
  region = "eu-central-1"
}

#######################
# Доступ до кластера EKS
#######################
data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

#######################
# Модулі
#######################

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
  subnet_ids    = module.vpc.public_subnets
  instance_type = "t3.small"
  desired_size  = 2
  max_size      = 2
  min_size      = 2
}

#######################
# Модуль Jenkins
#######################
module "jenkins" {
  source                 = "./modules/jenkins"
  cluster_name           = module.eks.eks_cluster_name
  jenkins_admin_password = var.jenkins_admin_password
  github_username        = var.github_username
  github_pat             = var.github_pat
  github_url             = var.github_url
  github_main_branch     = var.github_main_branch
  oidc_provider_arn      = module.eks.oidc_provider_arn
  oidc_provider_url      = module.eks.oidc_provider_url

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}


#Підключаємо модуль Argo CD
module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"
  github_username = var.github_username
  github_pat = var.github_pat
  github_url = var.github_tf_url
  github_main_branch = var.github_tf_branch
  helm_chart_path = var.helm_chart_path
}