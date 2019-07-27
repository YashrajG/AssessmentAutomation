resource "aws_security_group" "SecurityGroup" {
  name = "${var.security_group_name}"
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.security_group_name}"
    Project = "pe-training"
  }
}

output "security_group_id" {
  value = "${aws_security_group.SecurityGroup.id}"
}