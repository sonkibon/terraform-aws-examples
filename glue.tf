resource "aws_glue_catalog_database" "user" {
  name        = "user"
  description = "Database for user data"
}

resource "aws_glue_crawler" "user_database_crawler" {
  database_name = aws_glue_catalog_database.user.name
  name          = "user-database-crawler"
  role          = aws_iam_role.glue.arn
  description   = "Crawler to update tables in the user database of the glue data catalog"
  schedule      = var.glue_crawler_user_database_crawler_schedule

  s3_target {
    path = "s3://${aws_s3_bucket.user.bucket}/age"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.user.bucket}/gender"
  }

  s3_target {
    path = "s3://${aws_s3_bucket.user.bucket}/interests"
  }

  tags = {
    Name        = "user-database-crawler"
    Environment = var.env
    Application = "GlueCrawler"
    Owner       = "Son"
    ManagedBy   = "Terraform"
  }
}
