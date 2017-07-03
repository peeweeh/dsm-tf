resource "aws_security_group" "dsm_rds" {
  name        = "${var.project}-${var.env}-dsm-rds"
  description = "Used for Deep Security PostGres DB"
  vpc_id      = "${var.vpc_id}"

  # HTTP access from the VPC
  ingress {
    from_port       = 5432
    to_port         = 5433
    protocol        = "tcp"
    #security_groups = ["${var.access_security_group_ids}"]
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  tags {
    Name = "${var.project}-${var.env}-dsm-rds"
  }
}
