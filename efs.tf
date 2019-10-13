resource "aws_security_group" "ingress-efs-eks" {
  name = "ingress-efs-eks-sg"
  vpc_id = module.vpc.vpc_id

  // NFS
  ingress {
    security_groups = [module.eks_cluster.cluster_security_group_id, module.eks_cluster.worker_security_group_id]
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
  }

  // Terraform removes the default rule
  egress {
    security_groups = [module.eks_cluster.cluster_security_group_id, module.eks_cluster.worker_security_group_id]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

resource "aws_efs_file_system" "efs-eks" {
  creation_token = "efs-EKS"
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  encrypted = "true"
  tags = {
    Name = "EfsEKS"
    Terraform = "true"
    Environment = "test"
    Company = "Flo"
    DeployedBy = "NKorytko"
  }
}

resource "aws_efs_mount_target" "efs-mt-eks" {
  count = length(module.vpc.private_subnets)

  file_system_id  = aws_efs_file_system.efs-eks.id
  subnet_id = element(module.vpc.private_subnets, count.index)
  security_groups = [aws_security_group.ingress-efs-eks.id]
}