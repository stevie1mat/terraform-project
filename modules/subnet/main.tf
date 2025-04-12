resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.az
  map_public_ip_on_launch = var.public

  tags = {
    Name = "${var.env_name}-${var.public ? "Public" : "Private"}-Subnet-${var.az}"
  }
}