variable "aws_profile" {
  type = string
  default = "FloTest"
  description = "AWS profile name from ~/.aws/credentials"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
  description = "AWS Region"
}

variable "aws_azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
  description = "AWS Availability zones in AWS Region"
}

variable "vpc_cidr" {
  type = string
  default = "10.69.0.0/16"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.69.1.0/24", "10.69.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.69.11.0/24", "10.69.12.0/24"]
}

variable "eks_version" {
  type = string
  default = "1.14"
}

variable "cluster_name" {
  type = string
  default = "test-eks-flo"
}

variable "kubeconfig_filename" {
  type = string
  default = "./kubeconfig-flo-test"
}

variable "aws_authenticator_env_variables" {
  type = object({})
  default = {
    AWS_PROFILE = "FloTest"
  }
}

variable "map_users" {
  type = list(object({
    userarn = string
    username = string
    groups = list(string)
  }))
  default = [
    {
      userarn  = "arn:aws:iam::410029928830:user/nkorytko"
      username = "nkorytko"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_roles" {
  type = list(object({
    rolearn = string
    username = string
    groups = list(string)
  }))
  default = [
    {
      rolearn = "arn:aws:iam::410029928830:role/admin"
      username = "nkorytko"
      groups    = ["system:masters"]
    },
  ]
}