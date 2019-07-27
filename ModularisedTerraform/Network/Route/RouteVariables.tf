variable "route_table_id" {
  type = "string"
  description = "ID of the route table which this route belongs to."
}

variable "gateway_id" {
  type = "string"
  description = "ID of the Internet gateway which this route connects to."
}

variable "nat_gateway_id" {
  type = "string"
  description = "ID of the Network Address Translation gateway which this route connects to."
}

variable "is_to_nat" {
  type = bool
  description = "True if the route is to a NAT Gateway"
  default = false
}
