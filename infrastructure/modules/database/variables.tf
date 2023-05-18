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

variable "public_cidr_blocks" {
  description = "Public CIDR blocks"
  type        = list(string)
}