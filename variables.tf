variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name used for naming and tagging."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by public and private subnets."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 3
    error_message = "Exactly three Availability Zones must be provided."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the three public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "Exactly three public subnet CIDRs must be provided."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the three private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "Exactly three private subnet CIDRs must be provided."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version used by the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "cluster_endpoint_public_access" {
  description = "Boolean to enable/disable public access to the EKS cluster endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Boolean to enable/disable private access to the EKS cluster endpoint."
  type        = bool
  default     = true
}
variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks to allow access to the EKS cluster endpoint when public access is enabled."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_enabled_log_types" {
  description = "List of log types to enable for the EKS cluster."
  type        = list(string)
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "eks_administrator_role_arn" {
  description = "ARN of the IAM role granted administrative access to the EKS cluster."
  type        = string
}

variable "github_application_role_arn" {
  description = "ARN of the IAM role to be used by the GitHub application for EKS cluster management."
  type        = string
}


variable "github_terraform_role_arn" {
  description = "ARN of the IAM role to be used by the GitHub Terraform runner for EKS cluster management."
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types allowed for the self-managed worker group."
  type        = list(string)

  default = [
    "t3.medium",
    "t3a.medium",
    "t2.medium"
  ]

  validation {
    condition     = length(var.node_instance_types) >= 2
    error_message = "At least two instance types must be provided for mixed capacity."
  }
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 1
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 3
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 5
}

variable "node_on_demand_percentage" {
  description = "Percentage of worker capacity fulfilled by On-Demand instances."
  type        = number
  default     = 20

  validation {
    condition = (
      var.node_on_demand_percentage >= 0 &&
      var.node_on_demand_percentage <= 100
    )

    error_message = "On-Demand percentage must be between 0 and 100."
  }
}

variable "node_root_volume_size" {
  description = "Root EBS volume size for worker nodes in GiB."
  type        = number
  default     = 30
}

variable "node_root_volume_type" {
  description = "Root EBS volume type for worker nodes."
  type        = string
  default     = "gp3"
}