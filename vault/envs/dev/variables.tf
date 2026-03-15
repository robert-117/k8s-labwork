variable "aws_region" {
  type        = string
  description = "AWS region"
}
variable "environment" {
  type        = string
  description = "Environment name"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs"
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs"
}
variable "azs" {
  type        = list(string)
  description = "Availability zones"
}