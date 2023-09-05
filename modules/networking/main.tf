resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    tags = var.vpc_tags
}
# Create Internet_Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}
# Create Route table for Public_Subnets
resource "aws_route_table" "pub" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
}
}
# public_subnets######
resource "aws_subnet" "main" {
    count = var.subnet_count
    vpc_id = aws_vpc.main.id
    cidr_block = var.pub_cidrs[count.index]
}
# associate public subnets with public route table #####
resource "aws_route_table_association" "rpub" {
    count = var.subnet_count
    subnet_id = aws_subnet.main.*.id[count.index]
    route_table_id = aws_route_table.pub.id
}
# Create Route table for Private_Subnets
resource "aws_route_table" "pri" {
    vpc_id = aws_vpc.main.id
}
# private_subnets######
resource "aws_subnet" "main1" {
    count = var.subnet_count
    vpc_id = aws_vpc.main.id
    cidr_block = var.pri_cidrs[count.index]
}
# associate private subnets with private route table #####
resource "aws_route_table_association" "rpri" {
    count = var.subnet_count
    subnet_id = aws_subnet.main1.*.id[count.index]
    route_table_id = aws_route_table.pri.id
}
# create nat-instance#####
resource "aws_instance" "nat" {
    ami = "ami-04e5df0cf5946b2a4"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.main.*.id[0]
    associate_public_ip_address = true
    tags = {
        Name = "nat"
    }
}
    

  



  
