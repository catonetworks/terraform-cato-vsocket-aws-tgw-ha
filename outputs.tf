output "transit_gateway_vpc_attachment_id" {
  description = "The Attachment ID of the attachment of the Cato VPC to the Transit Gateway"
  value       = aws_ec2_transit_gateway_vpc_attachment.cato_vpc.id
}

output "transit_gateway_primary_subnet_id" {
  description = "The ID of the primary subnet of the Cato VPC"
  value       = aws_subnet.transit_gateway_primary.id
}

output "transit_gateway_primary_subnet_cidr" {
  description = "The CIDR of the primary subnet of the Cato VPC"
  value       = aws_subnet.transit_gateway_primary.cidr_block
}

output "transit_gateway_secondary_subnet_id" {
  description = "The ID of the secondary subnet of the Cato VPC"
  value       = aws_subnet.transit_gateway_secondary.id
}

output "transit_gateway_secondary_subnet_cidr" {
  description = "The CIDR of the secondary subnet of the Cato VPC"
  value       = aws_subnet.transit_gateway_secondary.cidr_block
}

output "transit_gateway_id" {
  value = var.tgw_id
  description = "The ID of the Transit Gateway"
  }

output "transit_gateway_routetable_id" {
  value = var.tgw_route_table_id
  description = "The ID of the Transit Gateway Route Table"
}

## The following attributes are exported:

output "sg_internal" {
  description = "ID of the internal security group that controls traffic for vSockets"
  value       = module.cato_deployment.sg_internal
}

output "sg_external" {
  description = "ID of the external security group that governs Internet‑facing traffic"
  value       = module.cato_deployment.sg_external
}

output "mgmt_eni_primary_id" {
  description = "Management ENI ID attached to the first vSocket instance"
  value       = module.cato_deployment.mgmt_eni_primary_id
}

output "mgmt_eni_secondary_id" {
  description = "Management ENI ID attached to the standby vSocket instance"
  value       = module.cato_deployment.mgmt_eni_secondary_id
}

output "wan_eni_primary_id" {
  description = "WAN ENI ID for outbound Internet connectivity on the first vSocket"
  value       = module.cato_deployment.wan_eni_primary_id
}

output "wan_eni_secondary_id" {
  description = "WAN ENI ID for outbound Internet connectivity on the standby vSocket"
  value       = module.cato_deployment.wan_eni_secondary_id
}

output "lan_eni_primary_id" {
  description = "LAN ENI ID providing internal LAN access to the first vSocket"
  value       = module.cato_deployment.lan_eni_primary_id
}

output "lan_eni_secondary_id" {
  description = "LAN ENI ID providing internal LAN access to the standby vSocket"
  value       = module.cato_deployment.lan_eni_secondary_id
}

output "mgmteip_primary" {
  description = "Public IP address of the primary management Elastic IP"
  value       = module.cato_deployment.mgmteip_primary
}

output "mgmteip_secondary" {
  description = "Public IP address of the secondary management Elastic IP"
  value       = module.cato_deployment.mgmteip_secondary
}

output "waneip_primary" {
  description = "Public IP address of the primary WAN Elastic IP"
  value       = module.cato_deployment.waneip_primary
}

output "waneip_secondary" {
  description = "Public IP address of the secondary WAN Elastic IP"
  value       = module.cato_deployment.waneip_secondary
}

output "mgmt_subnet_primary_id" {
  description = "Subnet ID dedicated to management traffic for vSockets"
  value       = module.cato_deployment.mgmt_subnet_primary_id
}

output "mgmt_subnet_secondary_id" {
  description = "Subnet ID dedicated to management traffic for vSockets"
  value       = module.cato_deployment.mgmt_subnet_secondary_id
}

output "wan_subnet_primary_id" {
  description = "Subnet ID dedicated to WAN traffic for vSockets"
  value       = module.cato_deployment.wan_subnet_primary_id
}

output "wan_subnet_secondary_id" {
  description = "Subnet ID dedicated to WAN traffic for vSockets"
  value       = module.cato_deployment.wan_subnet_secondary_id
}

output "lan_subnet_primary_id" {
  description = "Primary LAN subnet ID serving internal applications"
  value       = module.cato_deployment.lan_subnet_primary_id
}

output "lan_subnet_secondary_id" {
  description = "Secondary LAN subnet ID providing HA for internal traffic"
  value       = module.cato_deployment.lan_subnet_secondary_id
}

output "lan_subnet_primary_azid" {
  description = "Primary LAN subnet ID serving internal applications"
  value       = module.cato_deployment.lan_subnet_primary_azid
}

output "lan_subnet_secondary_azid" {
  description = "Secondary LAN subnet ID providing HA for internal traffic"
  value       = module.cato_deployment.lan_subnet_secondary_azid
}

output "wan_route_table_id" {
  description = "Route table ID associated with the WAN subnet"
  value       = module.cato_deployment.wan_route_table_id
}

output "lan_route_table_id" {
  description = "Route table ID associated with the LAN subnets"
  value       = module.cato_deployment.lan_route_table_id
}

output "aws_iam_role_name" {
  description = "Name of the IAM role granting vSocket HA permissions"
  value       = module.cato_deployment.aws_iam_role_name
}

output "aws_iam_policy_arn" {
  description = "ARN of the IAM policy attached to the HA role"
  value       = module.cato_deployment.aws_iam_policy_arn
}

output "aws_iam_instance_profile_name" {
  description = "Name of the IAM instance profile assigned to vSocket EC2 instances"
  value       = module.cato_deployment.aws_iam_instance_profile_name
}

output "aws_availability_zones_out" {
  description = "List of availability zones used for this deployment"
  value       = module.cato_deployment.aws_availability_zones_out
}

output "aws_instance_primary_vsocket_id" {
  description = "Instance ID of the primary vSocket EC2"
  value       = module.cato_deployment.aws_instance_primary_vsocket_id
}

output "aws_instance_secondary_vsocket_id" {
  description = "Instance ID of the secondary vSocket EC2"
  value       = module.cato_deployment.aws_instance_secondary_vsocket_id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID (existing or newly created) attached to the VPC"
  value       = module.cato_deployment.internet_gateway_id
}

output "vpc_id" {
  description = "VPC ID (existing or newly created) hosting the vSocket resources"
  value       = module.cato_deployment.vpc_id
}

output "cato_license_site" {
  description = "Metadata for the Cato license and site when a license ID is supplied"
  value       = module.cato_deployment.cato_license_site
}

output "lan_subnet_route_table_id" {
  value = module.cato_deployment.lan_subnet_route_table_id
  description = "The ID of the LAN Subnet Route Table"
}
