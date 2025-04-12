variable "vpc_id" {}
variable "cidr_block" {}
variable "az" {}
variable "env_name" {}
variable "public" {
  type    = bool
  default = true
}
