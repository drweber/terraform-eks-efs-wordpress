terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "2.32.0"
  profile = local.aws_profile
  region  = local.aws_region
}

//provider "kubernetes" {
//  version          = "~> 1.8"
//  load_config_file = true
//
//  //  config_path = "./${local.kubeconfig_filename}"
//  config_path = "${module.eks_cluster.kubeconfig_filename}"
//}
//
//provider "helm" {
//  version = "~> 0.10"
//
//  kubernetes {
//    load_config_file = true
//    config_path      = "./${module.eks_cluster.kubeconfig}"
//}
//
//  install_tiller  = true
//  tiller_image    = "gcr.io/kubernetes-helm/tiller:${local.helm_tiller_version}"
//  namespace       = "kube-system"
//  service_account = "tiller"
//}
//
//provider "null" {
//  version = "2.1.2"
//}
//
//provider "local" {
//  version = "1.2.2"
//}
//
//provider "template" {
//  version = "2.1.2"
//}
//
//provider "random" {
//  version = "2.2.1"
//}