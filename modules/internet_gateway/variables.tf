variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "env_name" {
  description = "Environment name for tagging"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to associate with the route table"
  type        = list(string)
}
