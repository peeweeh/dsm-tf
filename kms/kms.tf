resource "aws_kms_key" "master_key" {
  description             = "${var.project}-${var.env}-master"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}
