variable "elasticIPID" {
  type = "string"
  description = "ID of the elastic IP"
}

variable "subnet_id" {
  type = "string"
  description = "ID of the public subnet in which NAT resides"
}

variable "ProjectName" {
  type = "string"
  description = "name of the project"
  default = "pe-training"
}
