variable "security_group_name" {
  type = "string"
  description = "Name of the security group"
  Default = "yr-SecurityGroup"
}

variable "vpc_id" {
  type = "string"
  description = "ID of the VPC which this security group lies inside"
}