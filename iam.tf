resource "aws_iam_user" "read_s3_user" {
  name = "read-s3-user"

  tags = {
    Name        = "read-s3-user"
    Environment = var.env
    Application = "IAMUser"
    Owner       = var.owner_tag
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_user_policy" "read_s3_user_policy" {
  name = "read-s3-user-policy"
  user = aws_iam_user.read_s3_user.name

  policy = data.aws_iam_policy_document.read_s3_user.json
}

data "aws_iam_policy_document" "read_s3_user" {
  statement {
    sid    = "ListBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.user.arn,
    ]
  }

  statement {
    sid    = "GetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.user.arn}/*",
    ]
  }
}

resource "aws_iam_role" "glue" {
  name = "glue-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "glue" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.user.arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.user.arn}/*",
    ]
  }

  statement {
    actions = [
      "glue:*",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "glue" {
  name        = "glue"
  description = "Policy for AWS Glue crawler and job access to resources"
  policy      = data.aws_iam_policy_document.glue.json
}

resource "aws_iam_role_policy_attachment" "glue" {
  role       = aws_iam_role.glue.name
  policy_arn = aws_iam_policy.glue.arn
}
