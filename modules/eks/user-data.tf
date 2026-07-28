locals {
  nodeadm_config = <<-EOT
---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${aws_eks_cluster.this.name}
    apiServerEndpoint: ${aws_eks_cluster.this.endpoint}
    certificateAuthority: ${aws_eks_cluster.this.certificate_authority[0].data}
    cidr: ${aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr}
  kubelet:
    flags:
      - --node-labels=node-group=self-managed,environment=${lookup(var.tags, "Environment", "dev")}
EOT

  node_user_data = <<-EOT
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NODEADM"

--NODEADM
Content-Type: application/node.eks.aws

${local.nodeadm_config}
--NODEADM--
EOT
}