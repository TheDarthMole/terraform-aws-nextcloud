data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "nextcloud_ec2_iam_role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "s3_read_access" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject*",
      "s3:DeleteObject*",
    ]

    resources = [
      aws_s3_bucket.nextcloud_s3.arn,
      "${aws_s3_bucket.nextcloud_s3.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "join_policy" {
  name = "nextcloud_join_policy"
  role = aws_iam_role.ec2_iam_role.name

  policy = data.aws_iam_policy_document.s3_read_access.json

  depends_on = [aws_iam_role.ec2_iam_role]
}

resource "aws_iam_instance_profile" "nextcloud_web_instance_profile" {
  name = "nextcloud_web_instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}