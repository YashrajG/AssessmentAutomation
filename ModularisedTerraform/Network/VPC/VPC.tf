resource "aws_vpc" "assessVPC"{
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "${var.vpc_name}"
    Project = "${var.projectName}"
  }
}

resource "aws_internet_gateway" "assessVPC-IG" {
  vpc_id = "${aws_vpc.assessVPC.id}"
  tags = {
    Name = "${var.ig_name}"
    Project = "${var.projectName}"
  }
}

output "VPC_ID" {
  value = "${assessVPC.id}"
}

output "IG_ID" {
  value = "${assessVPC-IG.id}"
}