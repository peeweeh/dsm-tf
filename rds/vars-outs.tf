variable "project" {
  description = ""
  default     = "bryce"
}

variable "env" {
  description = ""
  default     = "prod"
}

variable "private_subnets" {
  default = []
}

variable "access_security_group_ids" {
  default = []
}

variable "vpc_id" {
  description = ""
  default     = "vpc"
}

variable "kms_key_id" {
  description = ""
  default     = ""
}

variable "db_password" {
  description = ""
  default     = ""
}

output "db_host" {
  description = ""
  value       = "${aws_db_instance.dsm_rds.address}"
}

variable "vpc_cidr" {
  description = ""
  default     = "10.0.0.0/16"
}
