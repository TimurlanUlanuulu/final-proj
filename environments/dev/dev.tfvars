aws_region   = "us-east-1"
environment  = "dev"
project_name = "eks-platform"

vpc_cidr = "10.10.0.0/16"

availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

public_subnet_cidrs = [
  "10.10.0.0/20",
  "10.10.16.0/20",
  "10.10.32.0/20"
]

private_subnet_cidrs = [
  "10.10.48.0/20",
  "10.10.64.0/20",
  "10.10.80.0/20"
]

kubernetes_version = "1.35"