module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = var.vpcname
  cidr = var.cidr

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  public_subnets  = ["10.0.96.0/19", "10.0.128.0/18", "10.0.192.0/18"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster-name
  cluster_version = "1.31"

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id                   =  module.vpc.vpc_id
#
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets


  eks_managed_node_group_defaults = {
    
    instance_types = [var.instance_type]
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_iam_user" "test-user"{
    name = var.testusername
    tags = {
        Description = "Test User"
    }
}

resource "aws_iam_policy" "testuser"{
    name = var.userpolicy
    policy = file("testuser-policy.json")
}

resource "aws_iam_user_policy_attachment" "testuser_access"{
    user = aws_iam_user.test-user.name
    policy_arn = aws_iam_policy.testuser.arn
}