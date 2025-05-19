#Data Resources to Doublecheck TGW ID and Route Table ID are correct.  
#Will Fail if bad values are passed before any resources are created.
data "aws_ec2_transit_gateway" "example" {
  id = var.tgw_id
}

data "aws_ec2_transit_gateway_route_table" "example" {
  id = var.tgw_route_table_id
}