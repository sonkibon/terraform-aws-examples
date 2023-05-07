resource "aws_s3_bucket" "user" {
  bucket = "user"

  tags = {
    Name        = "user"
    Environment = var.env
    Application = "S3Bucket"
    Owner       = "Son"
    ManagedBy   = "Terraform"
  }
}
