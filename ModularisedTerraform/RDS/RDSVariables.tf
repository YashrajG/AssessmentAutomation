variable "subnet_group_name" {
  description = "Name of RDS subnet group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type        = list(string)
}

variable "ProjectName" {
  type = "string"
  description = "Name of the Project"
  default = "pe-training"
}

variable "allocated_storage" {
  description = "Amount of allocated storage"
  type        = number
  default     = 20
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "db_name" {
  description = "Database name"
  type = string
  default = "yr-db"
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Password of database master"
  type        = string
}

variable "vpc_sg_ids" {
  description = "List of VPC security groups"
  type        = list(string)
}
