variable "vpc_cidr" {
  description = "VPC CIDR BLOCK"
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  description = "PRIVATE SUBNET CIDR"
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  description = "PUBLIC SUBNET CIDR"
  default = "10.0.0.0/24"
}

variable "region_location" {
  description = "selected region"
 }








