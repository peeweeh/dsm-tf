data "aws_ami" "dsm" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.3_HVM_GA-20161026-x86_64-1-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] #amazon
}

resource "aws_instance" "dsm" {
  ami                  = "${data.aws_ami.dsm.id}"
  subnet_id            = "${var.public_subnets[0]}"
  instance_type        = "t2.large"
  iam_instance_profile = "${aws_iam_instance_profile.dsm_profile.name}"

  vpc_security_group_ids = [
    "${aws_security_group.dsm_ec2.id}",
    "${var.admin_sg}",
  ]

  root_block_device {
    volume_size = "300"
  }

  associate_public_ip_address = true
  key_name                    = "${var.ec2_key}"

  tags {
    Name = "${var.project}-${var.env}-dsm"
  }

  user_data = <<-EOF
#!/usr/bin/env bash
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install awscli jq htop git wget
yum groupinstall "Development Tools" -y
yum install -y git wget htop
cd /tmp
curl -O https://dscloud.io.s3.amazonaws.com/DS101/DSM/Manager-Linux-10.1.395.x64.sh --insecure
chmod +x /tmp/Manager-Linux-10.1.395.x64.sh
echo DatabaseScreen.DatabaseType=PostgreSQL >> /tmp/install.properties
echo DatabaseScreen.DatabaseName=${var.db_master} >> /tmp/install.properties
echo DatabaseScreen.Hostname=${var.db_host}:5432 >> /tmp/install.properties
echo DatabaseScreen.Transport=TCP >> /tmp/install.properties
echo DatabaseScreen.Username=${var.db_master} >> /tmp/install.properties
echo DatabaseScreen.Password=${var.db_password} >> /tmp/install.properties
echo LicenseScreen.License.-1=${var.license_key} >> /tmp/install.properties
echo AddressAndPortsScreen.ManagerPort=443 >> /tmp/install.properties
echo AddressAndPortsScreen.HeartbeatPort=4120 >> /tmp/install.properties
echo CredentialsScreen.Administrator.Username=MasterAdmin >> /tmp/install.properties
echo CredentialsScreen.Administrator.Password=${var.db_password} >> /tmp/install.properties
echo CredentialsScreen.UseStrongPasswords=False >> /tmp/install.properties
echo UpgradeVerificationScreen.Overwrite=True
sh /tmp/Manager-Linux-10.1.395.x64.sh -q -console -varfile /tmp/install.properties
     EOF
}
