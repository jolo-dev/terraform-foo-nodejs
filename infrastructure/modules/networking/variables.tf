variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Map of public subnets"
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  description = "Map of private subnets"
  default = {
    "us-east-1a" = "10.0.3.0/24"
    "us-east-1b" = "10.0.4.0/24"
  }
}

