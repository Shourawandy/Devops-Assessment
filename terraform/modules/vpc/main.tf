data "aws_availability_zones" "available" {
  state = "available"
}

# ----------------------------
# VPC
# ----------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "devops-assessment-${var.environment}-vpc"
    Environment = var.environment
  }
}

# ----------------------------
# Public Subnets
# ----------------------------
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-assessment-${var.environment}-public-${count.index}"

    # Required for Internet-facing Load Balancer
    "kubernetes.io/role/elb" = "1"

    # Required for EKS
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# ----------------------------
# Private Subnets
# ----------------------------
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "devops-assessment-${var.environment}-private-${count.index}"

    # Required for Internal Load Balancer
    "kubernetes.io/role/internal-elb" = "1"

    # Required for EKS
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# ----------------------------
# Internet Gateway
# ----------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "devops-assessment-${var.environment}-igw"
  }
}

# ----------------------------
# Elastic IP for NAT Gateway
# ----------------------------
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "devops-assessment-${var.environment}-nat-eip"
  }
}

# ----------------------------
# NAT Gateway
# ----------------------------
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "devops-assessment-${var.environment}-nat"
  }
}

# ----------------------------
# Public Route Table
# ----------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "devops-assessment-${var.environment}-public-rt"
  }
}

# ----------------------------
# Private Route Table
# ----------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "devops-assessment-${var.environment}-private-rt"
  }
}

# ----------------------------
# Public Route Table Association
# ----------------------------
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ----------------------------
# Private Route Table Association
# ----------------------------
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
