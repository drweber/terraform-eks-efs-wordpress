output "efs-mount-target-dns" {
  description = "Address of the mount target provisioned."
  value       = aws_efs_mount_target.efs-mt-eks.0.dns_name
}

output "efs-mount-target-id" {
  description = "Address of the mount target provisioned."
  value       = aws_efs_mount_target.efs-mt-eks.0.file_system_id
}