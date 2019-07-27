resource "aws_nat_gateway" "NAT-GW" {
  allocation_id = "${var.elasticIPID}"
  subnet_id     = "${var.subnet_id}"

  tags = {
    Name = "gw NAT"
    Project = "${var.ProjectName}"
  }
}

output "NATGateway_id" {
  value = "${aws_nat_gateway.NAT-GW.id}"
}