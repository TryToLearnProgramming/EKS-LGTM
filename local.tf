locals {
  name            = "eks-lgtm-terraform"
  cluster_version = "1.31"

  ami_type       = "AL2_ARM_64"   # this is a arm based image
  instance_types = ["t4g.medium"] # this is a arm based instance
  capacity_type  = "ON_DEMAND"

  vpc_cidr        = "10.0.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets  = ["10.0.64.0/19", "10.0.96.0/19"]


  tags = var.tags
}
