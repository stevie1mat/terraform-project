variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "env_name" {
  description = "Name of the environment (e.g., Dev, Staging)"
  type        = string
}
