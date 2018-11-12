variable "name" {
    description = "The name of resource"
    default = "hello-world"
}

variable "environment" {
    description = "The environment where the resource will to allocate"
    default     = "production"
}

variable "instance_type" {
    description = "EC2 instance type"
    default     = "t2.micro"
}

variable "key_name" {
    default = "immutableinfra"
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
variable "monitoring" {
    default = "true"
}

variable "vpc_cidr_ipv4" {
  description = "CIDR for VPC - IPv4"
  default     = "10.0.0.0/16"
}

variable "owner_id" {
    default = ""
}

variable "region" {
    default = ""
}

variable "bucket_name" {
    default = ""
}