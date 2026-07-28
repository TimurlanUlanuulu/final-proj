output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}
output "eks_cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = module.eks.cluster_arn
}

output "eks_cluster_endpoint" {
  description = "Kubernetes API endpoint."
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster."
  value       = module.eks.cluster_version
}

output "eks_cluster_security_group_id" {
  description = "Security group associated with the EKS control plane."
  value       = module.eks.cluster_security_group_id
}

output "eks_worker_security_group_id" {
  description = "Security group assigned to self-managed worker nodes."
  value       = module.eks.worker_security_group_id
}

output "eks_node_iam_role_arn" {
  description = "ARN of the EKS worker node IAM role."
  value       = module.eks.node_iam_role_arn
}

output "eks_node_instance_profile_arn" {
  description = "ARN of the EKS worker node instance profile."
  value       = module.eks.node_instance_profile_arn
}

output "eks_node_launch_template_id" {
  description = "ID of the worker node launch template."
  value       = module.eks.node_launch_template_id
}

output "eks_node_autoscaling_group_name" {
  description = "Name of the worker node Auto Scaling Group."
  value       = module.eks.node_autoscaling_group_name
}

output "eks_node_ami_id" {
  description = "AMI used by the EKS worker nodes."
  value       = module.eks.node_ami_id
  sensitive = true
}