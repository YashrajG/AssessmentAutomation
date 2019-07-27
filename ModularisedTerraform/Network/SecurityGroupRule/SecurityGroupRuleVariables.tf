variable "is_cidr_source" {
  type = bool
  description = "True if the source is a CIDR as opposed to another security group"
}
variable "security_group_id" {
  type = "string"
  description = "ID of the security group which this rule is attached to"
}

variable "type" {
  type = "string"
  description = "describe your variable"
  default = "ingress"
}

variable "source_security_group_id" {
  type = "string"
  description = "ID of the Source Security group if present"
}

variable "cidr_blocks" {
  type = "string"
  description = "The source CIDR blocks if present"
}

variable "from_port" {
  type = "string"
  description = "The port number from which the message is passed"
}

variable "to_port" {
  type = "string"
  description = "the port number to which the message is passed"
}

variable "protocol" {
  type = "string"
  description = "The protocol which the rule applies to"
} 
