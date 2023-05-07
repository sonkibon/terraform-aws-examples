resource "aws_glue_catalog_database" "user" {
  name        = "user"
  description = "Database for user data"
}
