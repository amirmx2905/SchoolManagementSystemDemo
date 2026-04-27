variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "school-mgmt"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (for ALB)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs (for EC2, RDS, Vault)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "AZs to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID for us-east-1"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Ubuntu 22.04 LTS us-east-1
}

variable "app_instance_type" {
  description = "EC2 instance type for app servers"
  type        = string
  default     = "t3.small"
}

variable "vault_instance_type" {
  description = "EC2 instance type for Vault server"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "AWS key pair name for SSH access"
  type        = string
  default     = "school-mgmt-key"
}

variable "my_ip" {
  description = "Your public IP for SSH access (format: x.x.x.x/32)"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "schooldb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "schooladmin"
}

variable "db_password" {
  description = "RDS master password — pass via TF_VAR or terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "s3_bucket_name" {
  description = "Unique S3 bucket name for course files"
  type        = string
  default     = "school-mgmt-files"
}
