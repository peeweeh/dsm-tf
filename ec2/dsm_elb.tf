resource "aws_security_group" "dsm_elb_public" {
  name        = "${var.project}-${var.env}-dsm-elb-public"
  description = "Used for Deep Security Manager"

  vpc_id = "${var.vpc_id}"

  # HTTP access from the VPC

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 4120
    to_port     = 4120
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = 4122
    to_port     = 4122
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.project}-${var.env}-dsm-elb-public"
  }
}

resource "aws_elb" "dsm_elb" {
  name            = "${var.project}-${var.env}-elb"
  security_groups = ["${aws_security_group.dsm_elb_public.id}"]
  subnets         = ["${var.public_subnets}"]

  listener {
    instance_port     = 4120
    instance_protocol = "tcp"
    lb_port           = 4120
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 4122
    instance_protocol = "tcp"
    lb_port           = 4122
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "HTTPS"
    lb_port            = 443
    lb_protocol        = "HTTPS"
    ssl_certificate_id = "${var.acm_cert_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    target              = "HTTPS:443/SignIn.screen"
    interval            = 10
  }

  instances                   = ["${aws_instance.dsm.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.project}-${var.env}-elb"
  }
}
