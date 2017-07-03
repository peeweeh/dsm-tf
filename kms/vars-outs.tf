output "kms_key_id" {
  value = "${aws_kms_key.master_key.arn}"
}

variable "project" {
  description = ""
  default     = "bryce"
}

variable "env" {
  description = ""
  default     = "prod"
}
