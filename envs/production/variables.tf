variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "challengeone"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnets" {
  description = "CIDR blocks for private app subnets (EKS nodes)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_db_subnets" {
  description = "CIDR blocks for private database subnets"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "private_lambda_subnets" {
  description = "CIDR blocks for private Lambda subnets"
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.31.0/24"]
}

variable "single_nat_gateway" {
  description = "Use single NAT Gateway (cost saving for production)"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Create NAT Gateway per AZ (high availability)"
  type        = bool
  default     = false
}