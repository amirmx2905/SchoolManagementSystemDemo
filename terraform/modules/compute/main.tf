variable "project_name"        { type = string }
variable "ami_id"              { type = string }
variable "app_instance_type"   { type = string }
variable "vault_instance_type" { type = string }
variable "key_name"            { type = string }
variable "public_subnet_ids"   { type = list(string) }
variable "private_subnet_ids"  { type = list(string) }
variable "sg_ec2_id"           { type = string }
variable "sg_vault_id"         { type = string }

# EC2 App Instance 1 — auth-service + notifications-service
resource "aws_instance" "app1" {
  ami                    = var.ami_id
  instance_type          = var.app_instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.sg_ec2_id]
  key_name               = var.key_name

  tags = { Name = "${var.project_name}-app1" }
}

# EC2 App Instance 2 — students-service + courses-service
resource "aws_instance" "app2" {
  ami                    = var.ami_id
  instance_type          = var.app_instance_type
  subnet_id              = var.public_subnet_ids[1]
  vpc_security_group_ids = [var.sg_ec2_id]
  key_name               = var.key_name

  tags = { Name = "${var.project_name}-app2" }
}

# EC2 Vault Instance — private subnet
resource "aws_instance" "vault" {
  ami                    = var.ami_id
  instance_type          = var.vault_instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.sg_vault_id]
  key_name               = var.key_name

  tags = { Name = "${var.project_name}-vault" }
}

output "app_instance_1_public_ip"  { value = aws_instance.app1.public_ip }
output "app_instance_2_public_ip"  { value = aws_instance.app2.public_ip }
output "vault_instance_private_ip" { value = aws_instance.vault.private_ip }
