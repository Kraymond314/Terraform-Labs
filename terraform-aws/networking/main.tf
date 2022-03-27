# --- networking/main.tf ---

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}
resource "random_integer" "random" {
  min = 1
  max = 100

}

resource "aws_vpc" "labs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "kraymond-labs-${random_integer.random.id}"
  }
}

resource "aws_subnet" "labs_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.labs_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az.result[count.index]

  tags = {
    Name = "labs_public_${count.index + 1}"
  }
}
resource "aws_subnet" "labs_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.labs_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az.result[count.index]
  tags = {
    Name = "labs_private_${count.index + 1}"
  }
}

resource "aws_route_table_association" "labs_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.labs_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.labs_public_rt.id
}

resource "aws_internet_gateway" "labs_internet_gateway" {
  vpc_id = aws_vpc.labs_vpc.id

  tags = {
    Name = "labs_igw"
  }
}

resource "aws_route_table" "labs_public_rt" {
  vpc_id = aws_vpc.labs_vpc.id

  tags = {
    Name = "labs_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.labs_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.labs_internet_gateway.id
}

resource "aws_default_route_table" "labs_private_rt" {
  default_route_table_id = aws_vpc.labs_vpc.default_route_table_id

  tags = {
    Name = "labs_private"
  }
}

resource "aws_security_group" "labs_security" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.labs_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "labs_rds_subnetgroup" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "mtc_rds_subnetgroup"
  subnet_ids = aws_subnet.labs_private_subnet.*.id
  tags = {
    Name = "labs_rds_sng"
  }
}