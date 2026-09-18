module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Cluster info
  name                   = local.name
  kubernetes_version = "1.33"
  endpoint_public_access = true

  # Networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Control plane networking
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS addons
  addons = {
    vpc-cni = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    coredns = {
      most_recent = true
    }
  }

  # Managed node groups
  eks_managed_node_groups = {
    terraform-cluster-ng = {
      instance_types = ["t2.micro", "t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      capacity_type = "SPOT"

      attach_cluster_primary_security_group = true
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
