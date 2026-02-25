# ===================================
# Public Subnets
# ===================================
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-public-${var.environment}-${count.index + 1}"
    Environment              = var.environment
    Tier                     = "public"
    "kubernetes.io/role/elb" = "1"  # Para LoadBalancer público do EKS
  }
}

# ===================================
# Private Subnets - Application (EKS)
# ===================================
resource "aws_subnet" "private_app" {
  count = length(var.private_app_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_app_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.project_name}-private-app-${var.environment}-${count.index + 1}"
    Environment                       = var.environment
    Tier                              = "private-app"
    "kubernetes.io/role/internal-elb" = "1"  # Para LoadBalancer interno do EKS
  }
}

# ===================================
# Private Subnets - Database
# ===================================
resource "aws_subnet" "private_db" {
  count = length(var.private_db_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_db_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-private-db-${var.environment}-${count.index + 1}"
    Environment = var.environment
    Tier        = "private-db"
  }
}

# ===================================
# Private Subnets - Lambda
# ===================================
resource "aws_subnet" "private_lambda" {
  count = length(var.private_lambda_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_lambda_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-private-lambda-${var.environment}-${count.index + 1}"
    Environment = var.environment
    Tier        = "private-lambda"
  }
}