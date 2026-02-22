# ===================================
# Elastic IPs for NAT Gateways
# ===================================
resource "aws_eip" "nat" {
  count = var.single_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.availability_zones) : 1)

  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-eip-nat-${var.environment}-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.this]
}

# ===================================
# NAT Gateways
# ===================================
resource "aws_nat_gateway" "this" {
  count = var.single_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.availability_zones) : 1)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.project_name}-nat-${var.environment}-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.this]
}