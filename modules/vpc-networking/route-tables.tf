# ===================================
# Public Route Table
# ===================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.project_name}-rt-public-${var.environment}"
    Environment = var.environment
    Type        = "public"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ===================================
# Private Route Tables (App, DB, Lambda)
# ===================================
resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : length(var.availability_zones)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name        = "${var.project_name}-rt-private-${var.environment}-${count.index + 1}"
    Environment = var.environment
    Type        = "private"
  }
}

# Associação: Private App Subnets
resource "aws_route_table_association" "private_app" {
  count = length(var.private_app_subnets)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}

# Associação: Private DB Subnets
resource "aws_route_table_association" "private_db" {
  count = length(var.private_db_subnets)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}

# Associação: Private Lambda Subnets
resource "aws_route_table_association" "private_lambda" {
  count = length(var.private_lambda_subnets)

  subnet_id      = aws_subnet.private_lambda[count.index].id
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
}