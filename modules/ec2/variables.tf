variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "key_name" {}
variable "env_name" {}
variable "name" {}
variable "associate_public_ip" {
  type    = bool
  default = false
}
