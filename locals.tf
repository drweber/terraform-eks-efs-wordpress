locals {
  aws_profile = var.aws_profile
  aws_region = var.aws_region
  vpc_azs = var.aws_azs
  vpc_cidr = "10.69.0.0/16"
  private_subnets  = ["10.69.1.0/24", "10.69.2.0/24"]
  public_subnets   = ["10.69.11.0/24", "10.69.12.0/24"]
  eks_version = "1.14"
  cluster_name = "test-eks-flo"
  kubeconfig_filename = "./kubeconfig-flo-test"
  aws_authenticator_env_variables = {
    AWS_PROFILE = local.aws_profile
  }
  map_users = [
    {
      userarn  = "arn:aws:iam::410029928830:user/nkorytko"
      username = "nkorytko"
      groups   = ["system:masters"]
    },
  ]
  map_roles = [
    {
      rolearn = "arn:aws:iam::410029928830:role/admin"
      username = "nkorytko"
      groups    = ["system:masters"]
    },
  ]
}