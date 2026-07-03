variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}
