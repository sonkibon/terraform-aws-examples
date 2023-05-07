resource "aws_s3_bucket" "user" {
  bucket = "user"

  tags = {
    Name        = "user"
    Application = "S3Bucket"
    Owner       = "Son"
    ManagedBy   = "Terraform"
  }
}
