variable "project" {
  description = ""
  default     = "bryce"
}

variable "env" {
  description = ""
  default     = "prod"
}

variable "r53_zone_id" {
  default = ""
}

variable "r53_zone_name" {
  default = ""
}

variable "acm_cert_id" {
  default = ""
}

variable "vpc_cidr" {
  description = ""
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  description = ""
  default     = ""
}

variable "public_subnets" {
  default = []
}

variable "ec2_key" {
  default = "trend"
}

variable "admin_sg" {
  default = ""
}

output "ec2_security_group" {
  value = "${aws_security_group.dsm_ec2.id}"
}

variable "license_key" {
  default = ""
}

variable "db_master" {
  default = ""
}

variable "db_host" {
  default = ""
}

variable "db_password" {
  default = ""
}
