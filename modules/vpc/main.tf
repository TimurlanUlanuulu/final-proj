resource "aws_vpc" "redhat_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge (var.tags, {
    Name        = "${var.name}-vpc"
  })
  
}

resource "aws_internet_gateway" "redhat_igw" {
  vpc_id = aws_vpc.redhat_vpc.id

  tags = merge (var.tags, {
    Name        = "${var.name}-igw"
  })
}

resource "aws_subnet" "redhat_public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id            = aws_vpc.redhat_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name                                      = "${var.name}-public-${var.availability_zones[count.index]}"
      "kubernetes.io/role/elb"                   = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  )
}

resource "aws_subnet" "redhat_private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.redhat_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge (var.tags, {
    Name        = "${var.name}-private-subnet-${count.index + 1}"
  })
}

resource "aws_route_table" "redhat_public_route_table" {
  vpc_id = aws_vpc.redhat_vpc.id

  tags = merge (var.tags, {
    Name        = "${var.name}-public-rt"
  })
}

resource "aws_route" "redhat_public_route" {
  route_table_id         = aws_route_table.redhat_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.redhat_igw.id
}

resource "aws_route_table_association" "redhat_public_route_table_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.redhat_public_subnets[count.index].id
  route_table_id = aws_route_table.redhat_public_route_table.id
}

resource "aws_route_table" "redhat_private_route_table" {
  vpc_id = aws_vpc.redhat_vpc.id

  tags = merge (var.tags, {
    Name        = "${var.name}-private-rt"
  })
}

resource "aws_route_table_association" "redhat_private_route_table_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.redhat_private_subnets[count.index].id
  route_table_id = aws_route_table.redhat_private_route_table.id
}