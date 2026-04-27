variable "project_name" { type = string }
variable "s3_bucket_name" { type = string }

resource "aws_s3_bucket" "files" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = { Name = "${var.project_name}-files" }
}

resource "aws_s3_bucket_versioning" "files" {
  bucket = aws_s3_bucket.files.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "files" {
  bucket = aws_s3_bucket.files.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "files" {
  bucket                  = aws_s3_bucket.files.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" { value = aws_s3_bucket.files.bucket }
output "bucket_arn"  { value = aws_s3_bucket.files.arn }
