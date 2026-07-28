resource "aws_security_group" "cluster" {
  name_prefix = "${var.name}-cluster-"
  description = "Additional security group for the EKS control plane"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-cluster-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "workers" {
  name_prefix = "${var.name}-workers-"
  description = "Security group for self-managed EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-workers-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

#
# Control plane to worker nodes
#

resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_https" {
  security_group_id = aws_security_group.cluster.id

  description                  = "Allow control plane to communicate with worker nodes over HTTPS"
  referenced_security_group_id = aws_security_group.workers.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "cluster_to_workers_kubelet" {
  security_group_id = aws_security_group.cluster.id

  description                  = "Allow control plane to communicate with kubelet"
  referenced_security_group_id = aws_security_group.workers.id

  from_port   = 10250
  to_port     = 10250
  ip_protocol = "tcp"
}

#
# Worker nodes to control plane
#

resource "aws_vpc_security_group_ingress_rule" "cluster_from_workers_https" {
  security_group_id = aws_security_group.cluster.id

  description                  = "Allow worker nodes to communicate with the EKS API"
  referenced_security_group_id = aws_security_group.workers.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "workers_from_cluster_https" {
  security_group_id = aws_security_group.workers.id

  description                  = "Allow HTTPS traffic from the EKS control plane"
  referenced_security_group_id = aws_security_group.cluster.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "workers_from_cluster_kubelet" {
  security_group_id = aws_security_group.workers.id

  description                  = "Allow kubelet traffic from the EKS control plane"
  referenced_security_group_id = aws_security_group.cluster.id

  from_port   = 10250
  to_port     = 10250
  ip_protocol = "tcp"
}

#
# Worker-to-worker communication
#

resource "aws_vpc_security_group_ingress_rule" "workers_internal" {
  security_group_id = aws_security_group.workers.id

  description                  = "Allow communication between worker nodes"
  referenced_security_group_id = aws_security_group.workers.id

  ip_protocol = "-1"
}

#
# Worker outbound access
#

resource "aws_vpc_security_group_egress_rule" "workers_egress_ipv4" {
  security_group_id = aws_security_group.workers.id

  description = "Allow worker nodes outbound IPv4 access"
  cidr_ipv4   = "0.0.0.0/0"

  ip_protocol = "-1"
}