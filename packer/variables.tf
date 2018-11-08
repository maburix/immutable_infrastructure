variable "name" {
    description = "The name of resource"
    default = "hello-world"
}

variable "environment" {
    description = "The environment where the resource will to allocate"
    default     = "develop"
}

variable "instance_type" {
    description = "EC2 instance type"
    default     = "t2.micro"
}

variable "service" {
    description = "Service Tag"
    default     = "hello-world"
}

variable "owner" {
    description = "Owner Tag"
    default     = "ops"
}

variable "provisioner" {
    description = "Provisioner tool name"
    default     = "terraform"
}

variable "ip_public" {
    default = "True"
}

variable "key_name" {
    default = "dev"
}

variable "monitoring" {
    default = "true"
}

variable "vpc_cidr_ipv4" {
  description = "CIDR for VPC - IPv4"
  default     = "10.11.0.0/16"
}

variable "region" {
    default = ""
}

variable "bucket_name" {
    default = ""
}