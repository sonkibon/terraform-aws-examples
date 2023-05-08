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
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_job" "export_processed_age_data_to_s3" {
  name              = "export-processed-age-data-to-s3"
  role_arn          = aws_iam_role.glue.arn
  description       = "Process user's age data and upload to s3"
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = var.glue_job_export_processed_age_data_to_s3_number_of_workers

  command {
    script_location = "s3://${aws_s3_bucket.user.bucket}/job/export_processed_age_data_to_s3.py"
    python_version  = "3"
  }

  default_arguments = {
    "--ENV"                              = var.env
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue_job.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
  }

  tags = {
    Name        = "export-processed-age-data-to-s3"
    Environment = var.env
    Application = "GlueJob"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_job" "export_processed_gender_data_to_s3" {
  name              = "export-processed-gender-data-to-s3"
  role_arn          = aws_iam_role.glue.arn
  description       = "Process user's gender data and upload to s3"
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = var.glue_job_export_processed_gender_data_to_s3_number_of_workers

  command {
    script_location = "s3://${aws_s3_bucket.user.bucket}/job/export_processed_gender_data_to_s3.py"
    python_version  = "3"
  }

  default_arguments = {
    "--ENV"                              = var.env
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue_job.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
  }

  tags = {
    Name        = "export-processed-gender-data-to-s3"
    Environment = var.env
    Application = "GlueJob"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_job" "export_processed_interests_data_to_s3" {
  name              = "export-processed-interests-data-to-s3"
  role_arn          = aws_iam_role.glue.arn
  description       = "Generate interest data from user attribute information and upload to s3"
  glue_version      = "2.0"
  worker_type       = "G.2X"
  number_of_workers = var.glue_job_export_processed_interests_data_to_s3_number_of_workers

  command {
    script_location = "s3://${aws_s3_bucket.user.bucket}/job/export_processed_interests_data_to_s3.py"
    python_version  = "3"
  }

  default_arguments = {
    "--ENV"                                     = var.env
    "--continuous-log-logGroup"                 = aws_cloudwatch_log_group.glue_job.name
    "--enable-continuous-cloudwatch-log"        = "true"
    "--enable-continuous-log-filter"            = "true"
    "--enable-metrics"                          = "true"
    "--write-shuffle-files-to-s3"               = "true"
    "--write-shuffle-spills-to-s3"              = "true"
    "--conf spark.shuffle.glue.s3ShuffleBucket" = "s3://${aws_s3_bucket.user.bucket}"
    "--TempDir"                                 = "s3://${aws_s3_bucket.user.bucket}/shuffle/"
  }

  tags = {
    Name        = "export-processed-interests-data-to-s3"
    Environment = var.env
    Application = "GlueJob"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_job" "notify_workflow_status" {
  name              = "notify-workflow-status"
  role_arn          = aws_iam_role.glue.arn
  description       = "Notify workflow status"
  glue_version      = "4.0"
  worker_type       = "G.1X"
  number_of_workers = var.glue_job_notify_workflow_status_number_of_workers

  command {
    script_location = "s3://${aws_s3_bucket.user.bucket}/job/notify_workflow_status.py"
    python_version  = "3"
  }

  default_arguments = {
    "--ENV"                              = var.env
    "--slack_webhook_url"                = var.glue_job_default_arguments_slack_webhook_url
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue_job.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
  }

  tags = {
    Name        = "notify-workflow-status"
    Environment = var.env
    Application = "GlueJob"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_workflow" "user" {
  name        = "user"
  description = "Execute ETL jos against user data"

  tags = {
    Name        = "user"
    Environment = var.env
    Application = "GlueWorkflow"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_trigger" "export_processed_age_data_to_s3" {
  name          = "export-processed-age-data-to-s3"
  description   = "Triggers a job to process user age data and upload to s3 based on a schedule"
  schedule      = var.glue_trigger_export_processed_age_data_to_s3_schedule
  type          = "SCHEDULED"
  workflow_name = aws_glue_workflow.user.name

  actions {
    job_name = aws_glue_job.export_processed_age_data_to_s3.name
  }

  tags = {
    Name        = "export-processed-age-data-to-s3"
    Environment = var.env
    Application = "GlueTrigger"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_trigger" "export_processed_gender_data_to_s3" {
  name          = "export-processed-gender-data-to-s3"
  description   = "Triggers a job to process user gender data and upload to s3 based on status of the previous job"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.user.name

  actions {
    job_name = aws_glue_job.export_processed_gender_data_to_s3.name
  }

  predicate {
    conditions {
      job_name = aws_glue_job.export_processed_age_data_to_s3.name
      state    = "SUCCEEDED"
    }
  }

  tags = {
    Name        = "export-processed-gender-data-to-s3"
    Environment = var.env
    Application = "GlueTrigger"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_trigger" "export_processed_interests_data_to_s3" {
  name          = "export-processed-interests-data-to-s3"
  description   = "Triggers a job to process user interests data and upload to s3 based on status of the previous job"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.user.name

  actions {
    job_name = aws_glue_job.export_processed_interests_data_to_s3.name
  }

  predicate {
    conditions {
      job_name = aws_glue_job.export_processed_gender_data_to_s3.name
      state    = "SUCCEEDED"
    }
  }

  tags = {
    Name        = "export-processed-interests-data-to-s3"
    Environment = var.env
    Application = "GlueTrigger"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}

resource "aws_glue_trigger" "notify_workflow_status" {
  name          = "notify-workflow-status"
  description   = "Triggers a notification job when one of the workflow jobs fails"
  type          = "CONDITIONAL"
  workflow_name = aws_glue_workflow.user.name

  actions {
    job_name = aws_glue_job.notify_workflow_status.name
  }

  predicate {
    logical = "ANY"
    conditions {
      job_name = aws_glue_job.export_processed_age_data_to_s3.name
      state    = "FAILED"
    }
    conditions {
      job_name = aws_glue_job.export_processed_gender_data_to_s3.name
      state    = "FAILED"
    }
    conditions {
      job_name = aws_glue_job.export_processed_interests_data_to_s3.name
      state    = "FAILED"
    }
  }

  tags = {
    Name        = "notify-workflow-status"
    Environment = var.env
    Application = "GlueTrigger"
    Owner       = var.owner_tag
    ManagedBy   = var.managed_by_tag
  }
}
