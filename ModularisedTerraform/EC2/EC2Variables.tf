variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-026c8acd92718196b" # ubuntu 14.04 LTS
    }
}

variable "instance_type" {
  type = "string"
  description = "The type of the instance"
  default = "t2.micro"
}

variable "aws_key_name" {
  type = "string"
  description = "The name of the Key pair"
}

variable "vpc_security_group_id" {
  type = "string"
  description = "ID of the security group attached to the EC2 instance"
}

variable "subnet_id" {
  type = "string"
  description = "ID of the subnet in which the EC2 instance resides"
}

variable "instance_name" {
  type = "string"
  description = "Name of the instance"
  default = "yr-instance"
}

variable "ProjectName" {
  type = "string"
  description = "Name of the Project"
  default = "pe-training"
}
