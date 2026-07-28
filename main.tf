module "vpc" {
  source = "./modules/vpc"

  name                 = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.common_tags
  cluster_name         = "${local.name_prefix}-cluster"
}


module "eks" {
  source = "./modules/eks"

  name               = local.name_prefix
  cluster_name       = "${local.name_prefix}-cluster"
  kubernetes_version = var.kubernetes_version

  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  cluster_subnet_ids = module.vpc.public_subnet_ids
  worker_subnet_ids  = module.vpc.public_subnet_ids

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  cluster_enabled_log_types = var.cluster_enabled_log_types

  access_entries = {
    eks_administrator = {
      principal_arn = var.eks_administrator_role_arn
      type          = "STANDARD"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

      access_scope = {
        type = "cluster"
      }
    }


    github_application = {
      principal_arn = var.github_application_role_arn
      type          = "STANDARD"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

      access_scope = {
        type = "cluster"
      }
    }

    github_terraform = {
      principal_arn = var.github_terraform_role_arn
      type          = "STANDARD"
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

      access_scope = {
        type = "cluster"
      }
    }
  }

  tags = local.common_tags
}