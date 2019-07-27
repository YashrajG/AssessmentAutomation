resource "aws_subnet" "Subnet" {
  vpc_id = "${var.VPC_id}"

  cidr_block = "${var.subnet_cidr}"

  tags {
      Name = "${var.subnet_name}"
      Project = "${var.ProjectName}"
  }
}

output "subnet_id" {
  value = "${aws_subnet.Subnet.id}"
}