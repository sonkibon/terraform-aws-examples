variable "env" {
  default = "dev"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "owner_tag" {
  default = "Son"
}

#--------------------------------------------------------------
# Glue Variables
#--------------------------------------------------------------
variable "glue_crawler_user_database_crawler_schedule" {
  default = "cron(30 21 * * ? *)"
}

variable "glue_trigger_export_processed_age_data_to_s3_schedule" {
  default = "cron(0 22 * * ? *)"
}

variable "glue_job_export_processed_age_data_to_s3_number_of_workers" {
  default = 2
}

variable "glue_job_export_processed_gender_data_to_s3_number_of_workers" {
  default = 5
}

variable "glue_job_export_processed_interests_data_to_s3_number_of_workers" {
  default = 30
}

variable "glue_job_notify_workflow_status_number_of_workers" {
  default = 2
}

variable "glue_job_default_arguments_slack_webhook_url" {
  default = "https://hooks.slack.com/services/hoge/fuga/bar" # TODO: Replace this
}
