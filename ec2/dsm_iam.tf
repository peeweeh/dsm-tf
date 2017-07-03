resource "aws_iam_role_policy" "dsm_role_policy" {
  name = "${var.project}-${var.env}-dsm-role"
  role = "${aws_iam_role.dsm_role.id}"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": [
      "ec2:Describe*",
      "sns:publish*",
      "iam:ListAccountAliases",
      "s3:get*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "dsm_ssm_attach" {
  role       = "${aws_iam_role.dsm_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role" "dsm_role" {
  name = "${var.project}-${var.env}-dsm-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
      ]
    }
    EOF
}

resource "aws_iam_instance_profile" "dsm_profile" {
  name = "${var.project}-${var.env}-dsm-profile"
  role = "${aws_iam_role.dsm_role.name}"
}
