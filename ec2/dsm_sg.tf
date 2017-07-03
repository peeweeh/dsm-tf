resource "aws_security_group" "dsm_ec2" {
  name        = "${var.project}-${var.env}-dsm-ec2"
  description = "Used for Deep Security Manager"
  vpc_id      = "${var.vpc_id}"

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 4118
    to_port     = 4122
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}", "0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}", "0.0.0.0/0"]
  }

  tags {
    Name = "${var.project}-${var.env}-dsm-ec2"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
