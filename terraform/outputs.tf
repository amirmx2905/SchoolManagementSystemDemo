output "app_instance_1_public_ip" {
  description = "EC2 App Instance 1 public IP"
  value       = module.compute.app_instance_1_public_ip
}

output "app_instance_2_public_ip" {
  description = "EC2 App Instance 2 public IP"
  value       = module.compute.app_instance_2_public_ip
}

output "vault_instance_private_ip" {
  description = "Vault EC2 private IP"
  value       = module.compute.vault_instance_private_ip
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.database.rds_endpoint
}

output "s3_bucket_name" {
  description = "S3 bucket name for course files"
  value       = module.storage.bucket_name
}
