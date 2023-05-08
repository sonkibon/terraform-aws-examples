resource "aws_cloudwatch_log_group" "glue_job" {
  name              = "glue-job"
  retention_in_days = 14
}
