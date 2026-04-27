variable "project_name"       { type = string }
variable "db_name"            { type = string }
variable "db_username"        { type = string }
variable "db_instance_class"  { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "sg_rds_id"          { type = string }

variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.sg_rds_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  storage_encrypted      = true

  tags = { Name = "${var.project_name}-rds" }
}

output "rds_endpoint" { value = aws_db_instance.postgres.endpoint }
output "rds_arn"      { value = aws_db_instance.postgres.arn }
