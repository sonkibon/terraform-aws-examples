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
