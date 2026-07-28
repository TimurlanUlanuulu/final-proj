terraform {
  backend "s3" {
    bucket       = "final-project-terraform-state-08-27-2026"
    key          = "eks-cluster/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}