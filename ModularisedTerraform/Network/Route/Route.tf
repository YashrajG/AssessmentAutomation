resource "aws_route" "PublicRoute" {
  count = var.is_to_nat ? 0 : 1
  route_table_id = "${var.route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${var.gateway_id}"
}

resource "aws_route" "PrivateRoute" {
  count = var.is_to_nat ? 1 : 0
  route_table_id = "${var.route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${var.nat_gateway_id}"
}
