variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
}

variable "private_cidr_blocks" {
  description = "Private CIDR blocks"
  type        = list(string)
}
