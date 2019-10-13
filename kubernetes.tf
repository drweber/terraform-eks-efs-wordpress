#https://docs.aws.amazon.com/en_us/eks/latest/userguide/efs-csi.html

resource "local_file" "pv" {
  depends_on = [
    aws_efs_mount_target.efs-mt-eks,
  ]

  filename = "./yamls/pv.yaml"

  content = <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv-volume
  labels:
    app: wordpress
spec:
  capacity:
    storage: 100Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: efs-sc
  csi:
    driver: efs.csi.aws.com
    volumeHandle: ${aws_efs_mount_target.efs-mt-eks.0.file_system_id}
EOF
}

resource "null_resource" "csi-driver" {
  depends_on = [
    aws_efs_mount_target.efs-mt-eks,
    module.eks_cluster.cluster_id,
  ]
  triggers = {
    id = local_file.pv.id
    cluster_id = module.eks_cluster.cluster_id
  }

  provisioner "local-exec" {
    command = <<EOT
    export KUBECONFIG=${local.kubeconfig_filename}
    kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
EOT
  }
}

resource "null_resource" "wp-deploy" {
  depends_on = [
    null_resource.csi-driver,
    local_file.pv,
    module.eks_cluster.cluster_id,
  ]
  triggers = {
    id = local_file.pv.id
    cluster_id = module.eks_cluster.cluster_id
  }

  provisioner "local-exec" {
    command = <<EOT
    export KUBECONFIG=${local.kubeconfig_filename}
    kubectl  -k ./yamls
EOT
  }
}