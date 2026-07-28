

variable "name" {
  description = "Name prefix for EKS resources."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version used by the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster is deployed."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the EKS VPC."
  type        = string
}

variable "cluster_subnet_ids" {
  description = "Subnet IDs used by the EKS control plane."
  type        = list(string)

  validation {
    condition     = length(var.cluster_subnet_ids) >= 2
    error_message = "The EKS cluster must use at least two subnets."
  }
}

variable "worker_subnet_ids" {
  description = "Subnet IDs where self-managed worker nodes will be deployed."
  type        = list(string)

  validation {
    condition     = length(var.worker_subnet_ids) >= 2
    error_message = "Worker nodes must use at least two subnets."
  }
}

variable "cluster_endpoint_public_access" {
  description = "Whether the public EKS API endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Whether the private EKS API endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to communicate with the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_enabled_log_types" {
  description = "EKS control-plane log types sent to CloudWatch."
  type        = list(string)

  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

variable "access_entries" {
  description = "IAM principals granted access to the EKS cluster."

  type = map(object({
    principal_arn = string
    type          = optional(string, "STANDARD")
    policy_arn    = optional(string)
    access_scope = optional(object({
      type       = string
      namespaces = optional(list(string))
    }))
  }))

  default = {}
}

variable "tags" {
  description = "Common tags applied to EKS resources."
  type        = map(string)
  default     = {}
}


variable "node_instance_types" {
  description = "Instance types available to the mixed instances worker group."
  type        = list(string)

  validation {
    condition     = length(var.node_instance_types) >= 2
    error_message = "At least two instance types must be provided."
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
  description = "Percentage of capacity above the base fulfilled by On-Demand instances."
  type        = number
  default     = 20
}

variable "node_root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 30
}

variable "node_root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "node_ami_id" {
  description = "Optional custom AMI ID for worker nodes. When null, the recommended EKS AL2023 AMI is used."
  type        = string
  default     = null
}