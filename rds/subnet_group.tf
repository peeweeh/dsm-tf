resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project}-${var.env}-db-group"
  subnet_ids = ["${var.private_subnets}"]

  tags {
    Name = "${var.project}-${var.env}-db-group"
  }
}
