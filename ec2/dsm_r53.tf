resource "aws_route53_record" "dsm_record" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.r53_zone_name}"
  type    = "CNAME"
  ttl     = "5"
  records = ["${aws_elb.dsm_elb.dns_name}"]
}
