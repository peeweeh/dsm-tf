# Use Project and Environment Variables just for naming purposes
#KMS - Creates a DSM
module "kms" {
  source  = "kms"
  project = "${var.project}"
  env     = "${var.env}"
}

#RDS - Launches a Postgres RDS Instance
#  vpc_id                    = ID of the VPC to be used
#  private_subnets           = A List of subnets where RDS will be Stored, this will create a subnet Group
#  kms_key_id                = "${module.kms.kms_key_id}"
#  access_security_group_ids = Security Groups of EC2 Instances that needs access to this postgres DB
#  db_password               = Password of the Database
#  vpc_cidr                  = Password of the CIDR of the VPC
module "rds" {
  source                    = "rds"
  project                   = "${var.project}"
  env                       = "${var.env}"
  vpc_id                    = "${module.vpc.vpc_id}"
  private_subnets           = ["${module.private_subnet.ids}"]
  kms_key_id                = "${module.kms.kms_key_id}"
  access_security_group_ids = ["${module.ec2.ec2_security_group}"]
  db_password               = "${var.db_password}"
  vpc_cidr                  = "${var.vpc_cidr}"
}

#ec2 - Launches 1 Deep Security Manager
#  public_subnets = Subnets of the DSM and ELB
#  r53_zone_id    = Route 53 Zone ID for the domain
#  r53_zone_name  = Domain Name
#  acm_cert_id    = Cert ID from ACM
#  ec2_key        = Key for the DSM Instance
#  admin_sg       = Security Group for Admin Access of DSM
#  db_host        = DS RDS Hostname This should be pre-populated from the RDS Block
#  db_password    = DS RDS Password
#  db_master      = Master Username
#  license_key    = License key for Deep Security
module "ec2" {
  source         = "ec2"
  project        = "${var.project}"
  env            = "${var.env}"
  vpc_id         = "${module.vpc.vpc_id}"
  vpc_cidr       = "${var.vpc_cidr}"
  public_subnets = ["${module.public_subnet.ids}"]
  r53_zone_id    = "${var.r53_zone_id}"
  r53_zone_name  = "${var.r53_zone_name}"
  acm_cert_id    = "${var.acm_cert_id}"
  ec2_key        = "${var.ec2_key}"
  admin_sg       = "${module.admin_sg.admin_sg_id}"
  db_host        = "${module.rds.db_host}"
  db_password    = "${var.db_password}"
  db_master      = "${var.db_master}"
  license_key    = "${var.license_key}"
}
