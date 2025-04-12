resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_name}-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_name}-Public-RT"
  }
}

resource "aws_route_table_association" "assoc" {
  for_each = toset(var.public_subnet_ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}
