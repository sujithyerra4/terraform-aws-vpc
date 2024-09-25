#  creating VPC
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
  var.common_tags,
  var.vpc_tags,
  {
    Name= local.resource_name
  }
  )
  
}

# creating igw


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
  var.common_tags,
  var.igw_tags,
  {
   Name=local.resource_name
  }
  )
}

# creating subnets

resource "aws_subnet" "public" {
  count=length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  map_public_ip_on_launch=true
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_name[count.index]

   tags = merge(
  var.common_tags,
  var.public_subnet_tags,
  {
   Name="${local.resource_name}-public-${local.az_name[count.index]}"
  }
  )
}

resource "aws_subnet" "private" {
  count=length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_name[count.index]

   tags = merge(
 var.common_tags,
  var.private_subnet_tags,
  {
   Name="${local.resource_name}-private-${local.az_name[count.index]}"
  }
  )
}

resource "aws_subnet" "database" {
  count=length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_name[count.index]

   tags = merge(
  var.common_tags,
  var.database_subnet_tags,
  {
   Name="${local.resource_name}-database-${local.az_name[count.index]}"
  }
  )
}

# database subnet group

resource "aws_db_subnet_group" "default" {
  name       = local.resource_name
  subnet_ids = aws_subnet.database[*].id
   tags = merge(
   var.common_tags,
  var.subnet_group_tags,
  {
   Name=local.resource_name
  }
  )
}

# creating elastic ip

resource "aws_eip" "nat" {
  domain   = "vpc"
}

# creating NAT gateway

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  

    tags = merge(
  var.common_tags,
  var.NAT_tags,
  {
   Name=local.resource_name
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}