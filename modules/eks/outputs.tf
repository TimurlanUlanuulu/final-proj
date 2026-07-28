output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS Kubernetes API."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster."
  value       = aws_eks_cluster.this.version
}

output "cluster_security_group_id" {
  description = "Security group associated with the EKS control plane."
  value       = aws_security_group.cluster.id
}

output "worker_security_group_id" {
  description = "Security group used by self-managed worker nodes."
  value       = aws_security_group.workers.id
}

output "cluster_iam_role_arn" {
  description = "ARN of the EKS cluster IAM role."
  value       = aws_iam_role.cluster.arn
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL of the EKS cluster."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}