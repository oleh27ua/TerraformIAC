#Create VPC 
resource "aws_vpc" "NodeJS_App_ASG_VPC" {
 cidr_block = var.vpc_cidr
 
 tags = {
   Name = "NodeJS_App_ASG_VPC"
 }
}


# Create subnets in different AZs for high availability
resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.NodeJS_App_ASG_VPC.id
 cidr_block = var.public_subnet_cidrs[count.index]
 availability_zone = var.availability_zones[count.index]
 map_public_ip_on_launch = true
 
 tags = merge(
 {
   Name = "NodeJS_App_ASG_Public_Subnet_${var.availability_zones[count.index]}"
 }
 )
}



# Create an Internet Gateway
resource "aws_internet_gateway" "NodeJS_App_ASG_IG" {
  vpc_id = aws_vpc.NodeJS_App_ASG_VPC.id
  
  tags = {
    Name = "NodeJS_App_ASG_IGW"
  }
}

# Create a route table
resource "aws_route_table" "NodeJS_App_ASG_RT" {
  vpc_id = aws_vpc.NodeJS_App_ASG_VPC.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.NodeJS_App_ASG_IG.id
  }
  
  tags = {
    Name = "NodeJS_App_ASG_RT"
  }
}

# Associate route table with subnets
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.NodeJS_App_ASG_RT.id
}