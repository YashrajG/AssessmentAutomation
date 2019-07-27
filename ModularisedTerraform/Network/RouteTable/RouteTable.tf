resource "aws_route_table" "RouteTable" {
  vpc_id = "${var.vpc_id}"

  tags {
      Name = "${var.RouteTableName}"
  }
}

output "route_table_id" {
  value = "${aws_route_table.RouteTable.id}"
}