variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "database_ip" {
  description = "Database IP"
}

variable "ami_id" {
  description = "AMI ID"
  default     = "ami-0d5eff06f840b45e9"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "Desired capacity"
  default     = 1
}

variable "launch_configuration_name_prefix" {
  description = "Launch configuration name prefix"
  default     = "foo"
}

variable "key_pair_name" {
  description = "Name of the key pair to use for SSH access"
}
