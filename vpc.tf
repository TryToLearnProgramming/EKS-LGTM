module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true

  enable_ipv6            = false
  create_egress_only_igw = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags

}
# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

# Output the IDs of the public subnets
output "public_subnet_ids" {
  description = "List of IDs of public subnets."
  value       = module.vpc.public_subnets
}

# Output the IDs of the private subnets
output "private_subnet_ids" {
  description = "List of IDs of private subnets."
  value       = module.vpc.private_subnets
}

# Output the single NAT Gateway ID (if applicable)
output "nat_gateway_id" {
  description = "The ID of the single NAT Gateway that has been created."
  value       = try(module.vpc.nat_gateway_ids[0], "N/A")
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway attached to the VPC."
  value       = module.vpc.igw_id
}

# Output the Egress Only Internet Gateway ID (for IPv6, if applicable)
output "egress_only_internet_gateway_id" {
  description = "The ID of the Egress Only Internet Gateway attached to the VPC (for IPv6)."
  value       = try(module.vpc.eigw_id, "N/A")
}

