resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.69.0.0/16",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.69.0.0/16",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "vpc" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc?ref=v2.17.0"

  name = "eks-vpc"
  cidr = local.vpc_cidr

  azs              = local.vpc_azs
  private_subnets  = local.private_subnets
  public_subnets   = local.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "test"
    Company = "Flo"
    DeployedBy = "NKorytko"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks_cluster" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-eks.git?ref=v6.0.2"

//  subnets = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  subnets = module.vpc.public_subnets
  cluster_name                               = local.cluster_name
  cluster_version                            = local.eks_version
  write_kubeconfig                           = true
  kubeconfig_name                            = local.kubeconfig_filename
    manage_aws_auth = true
    kubeconfig_aws_authenticator_env_variables = local.aws_authenticator_env_variables

  tags = {
    Terraform = "true"
    Environment = "test"
    Company = "Flo"
    DeployedBy = "NKorytko"
  }

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      public_ip = true
    }
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_users                            = local.map_users
  map_roles                            = local.map_roles
  map_accounts                         = []
}