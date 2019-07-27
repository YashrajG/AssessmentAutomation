variable "subnet_cidr" {
    description = "CIDR for the Subnet"
    default = "10.0.0.0/24"
}
variable "subnet_name" {
    description = "Name for the Public Subnet"
    default = "yr-Subnet"
}

variable "vpc_id" {
    description = "ID for the VPC"
}

variable "projectName" {
  type = "string"
  description = "Name of the project which the Subnet is a part of."
  default = "pe-training"
}