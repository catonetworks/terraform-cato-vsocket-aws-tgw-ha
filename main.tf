
module "cato_deployment" {
  source                      = "catonetworks/vsocket-aws-ha-vpc/cato"
  version                     = "~> 0.1.0"
  token                       = var.token
  account_id                  = var.account_id
  vpc_id                      = var.vpc_id
  ingress_cidr_blocks         = var.ingress_cidr_blocks
  lan_ingress_cidr_blocks     = var.ingress_cidr_blocks
  key_pair                    = var.key_pair
  subnet_range_mgmt_primary   = var.subnet_range_mgmt_primary
  subnet_range_mgmt_secondary = var.subnet_range_mgmt_secondary
  subnet_range_wan_primary    = var.subnet_range_wan_primary
  subnet_range_wan_secondary  = var.subnet_range_wan_secondary
  subnet_range_lan_primary    = var.subnet_range_lan_primary
  subnet_range_lan_secondary  = var.subnet_range_lan_secondary
  mgmt_eni_primary_ip         = var.mgmt_eni_primary_ip
  mgmt_eni_secondary_ip       = var.mgmt_eni_secondary_ip
  wan_eni_primary_ip          = var.wan_eni_primary_ip
  wan_eni_secondary_ip        = var.wan_eni_secondary_ip
  lan_eni_primary_ip          = var.lan_eni_primary_ip
  lan_eni_secondary_ip        = var.lan_eni_secondary_ip
  vpc_range                   = var.vpc_network_range
  native_network_range        = var.native_network_range
  site_name                   = var.site_name
  site_description            = var.site_description
  site_location               = var.site_location
  tags                        = var.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "cato_vpc" {
  vpc_id             = module.cato_deployment.vpc_id
  transit_gateway_id = var.tgw_id
  subnet_ids = [
    aws_subnet.transit_gateway_primary.id,
    aws_subnet.transit_gateway_secondary.id
  ]
}

resource "aws_route" "cato_private_to_tgw" {
  route_table_id         = module.cato_deployment.lan_subnet_route_table_id
  destination_cidr_block = var.native_network_range
  transit_gateway_id     = var.tgw_id
  depends_on             = [aws_ec2_transit_gateway_vpc_attachment.cato_vpc]
}

resource "aws_ec2_transit_gateway_route" "all-zeros-cato" {
  count                          = var.build_default_tgw_route_to_cato ? 1 : 0
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.cato_vpc.id
  transit_gateway_route_table_id = var.tgw_route_table_id
  depends_on                     = [aws_route.cato_private_to_tgw]
}

resource "aws_subnet" "transit_gateway_primary" {
  vpc_id               = var.vpc_id == null ? module.cato_deployment.vpc_id : var.vpc_id
  cidr_block           = var.subnet_range_tgw_primary
  availability_zone_id = module.cato_deployment.lan_subnet_primary_azid
  tags = merge(var.tags, {
  Name = "${var.site_name}-TGW-Subnet-Primary" })
}

resource "aws_subnet" "transit_gateway_secondary" {
  vpc_id               = var.vpc_id == null ? module.cato_deployment.vpc_id : var.vpc_id
  cidr_block           = var.subnet_range_tgw_secondary
  availability_zone_id = module.cato_deployment.lan_subnet_secondary_azid
  tags = merge(var.tags, {
  Name = "${var.site_name}-TGW-Subnet-Primary" })
}

resource "aws_route_table_association" "lan_subnet_route_table_association_primary" {
  subnet_id      = aws_subnet.transit_gateway_primary.id
  route_table_id = module.cato_deployment.lan_route_table_id
}

resource "aws_route_table_association" "lan_subnet_route_table_association_secondary" {
  subnet_id      = aws_subnet.transit_gateway_secondary.id
  route_table_id = module.cato_deployment.lan_route_table_id
}
