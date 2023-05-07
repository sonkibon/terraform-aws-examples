resource "aws_iam_user" "read_s3_user" {
  name = "read-s3-user"

  tags = {
    Name        = "read-s3-user"
    Environment = var.env
    Application = "IAMUser"
    Owner       = "Son"
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
