resource "aws_db_instance" "dsm_rds" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = "postgres"

  # engine_version       = "5.6.17"
  instance_class    = "db.t2.medium"
  name              = "dsm"
  username          = "dsm"
  password          = "${var.db_password}"
  storage_encrypted = true

  kms_key_id = "${var.kms_key_id}"

  # final_snapshot_identifier = "${var.project}-${var.env}-dsm-rds-final"
  identifier             = "${var.project}-${var.env}-dsm-rds"
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.dsm_rds.id}"]

  tags {
    Name = "${var.project}-${var.env}-dsm-rds"
  }
}
