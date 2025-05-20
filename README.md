# CATO VSOCKET AWS Transit Gateway Terraform module

Terraform module which creates a VPC, required subnets, elastic network interfaces, security groups, route tables, an AWS Socket Site in the Cato Management Application (CMA), and deploys a virtual socket ec2 instance in AWS.  Then attaches the deployment to a transit gateway and specifies a default route to send traffic to the virtual socket ec2 instance.

For the vpc_id and internet_gateway_id leave null to create new or add an id of the already created resources to use existing.

Requires an aws transit gateway ID (tgw_id) and transit gateway route table ID (tgw_route_table_id) to connect with.

<details>
<summary>Example AWS VPC and Internet Gateway Resources</summary>

Create the AWS VPC and Internet Gateway resources using the following example, and create these resources first before running the module:

```hcl
resource "aws_vpc" "cato-vpc" {
  cidr_block = var.vpc_range
  tags = {
    Name = "${var.site_name}-VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "${var.site_name}-IGW"
  }
  vpc_id = aws_vpc.cato-vpc.id
}

terraform apply -target=aws_vpc.cato-vpc -target=aws_internet_gateway.internet_gateway
```

Reference the resources as input variables with the following syntax:
```hcl
  vpc_id           = aws_vpc.cato-vpc.id
  internetGateway  = aws_internet_gateway.internet_gateway.id 
```

</details>

## NOTE
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).

## Usage

```hcl
provider "cato" {
  baseurl    = var.baseurl
  account_id = var.account_id
  token      = var.token
}

provider "aws" {
  region = var.region
}

variable "baseurl" {}
variable "account_id" {}
variable "token" {}
variable "region" {
  default = "us-west-2"
}


module "tgw" {
  source                      = "catonetworks/vsocket-aws-tgw-ha/cato"
  token                       = var.token
  account_id                  = var.account_id
  vpc_id                      = null
  internet_gateway_id         = null
  key_pair                    = "Your-key-pair-name-here"
  vpc_network_range           = "10.132.0.0/22"
  native_network_range        = "10.128.0.0/13"
  subnet_range_mgmt_primary   = "10.132.0.0/25"
  subnet_range_mgmt_secondary = "10.132.0.128/25"
  subnet_range_wan_primary    = "10.132.1.0/25"
  subnet_range_wan_secondary  = "10.132.1.128/25"
  subnet_range_lan_primary    = "10.132.2.0/25"
  subnet_range_lan_secondary  = "10.132.2.128/25"
  subnet_range_tgw_primary    = "10.132.3.0/25"
  subnet_range_tgw_secondary  = "10.132.3.128/25"
  mgmt_eni_primary_ip         = "10.132.0.5"
  mgmt_eni_secondary_ip       = "10.132.0.133"
  wan_eni_primary_ip          = "10.132.1.5"
  wan_eni_secondary_ip        = "10.132.1.133"
  lan_eni_primary_ip          = "10.132.2.5"
  lan_eni_secondary_ip        = "10.132.2.133"
  ingress_cidr_blocks         = ["0.0.0.0/0"]
  site_name                   = "Your-Cato-site-name-here"
  tgw_id                      = "tgw-01234567890abcdef"
  tgw_route_table_id          = "tgw-rtb-01234567890abcdef"
  site_description            = "Your Cato site desc here"
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
  }
  tags = {
    Environment = "Production"
    Owner       = "Operations Team"
  }
}
```

## Site Location Reference

For more information on site_location syntax, use the [Cato CLI](https://github.com/catonetworks/cato-cli) to lookup values.

```bash
$ pip3 install catocli
$ export CATO_TOKEN="your-api-token-here"
$ export CATO_ACCOUNT_ID="your-account-id"
$ catocli query siteLocation -h
$ catocli query siteLocation '{"filters":[{"search": "San Diego","field":"city","operation":"exact"}]}' -p
```

## Authors

Module is maintained by [Cato Networks](https://github.com/catonetworks) with help from [these awesome contributors](https://github.com/catonetworks/terraform-cato-vsocket-aws-vpc/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/catonetworks/terraform-cato-vsocket-aws-vpc/tree/master/LICENSE) for full details.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | ~> 0.0.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cato_deployment"></a> [cato\_deployment](#module\_cato\_deployment) | catonetworks/vsocket-aws-ha-vpc/cato | ~> 0.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.all-zeros-cato](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.cato_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route.cato_private_to_tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table_association.lan_subnet_route_table_association_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.lan_subnet_route_table_association_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.transit_gateway_primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.transit_gateway_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_ec2_transit_gateway.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |
| [aws_ec2_transit_gateway_route_table.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway_route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Cato account ID | `number` | n/a | yes |
| <a name="input_baseurl"></a> [baseurl](#input\_baseurl) | Cato Networks API URL | `string` | `"https://api.catonetworks.com/api/v1/graphql2"` | no |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | Set CIDR to receive traffic from the specified IPv4 CIDR address ranges<br/>	For example x.x.x.x/32 to allow one specific IP address access, 0.0.0.0/0 to allow all IP addresses access, or another CIDR range<br/>    Best practice is to allow a few IPs as possible<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `list(any)` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of the vSocket | `string` | `"c5.xlarge"` | no |
| <a name="input_internet_gateway_id"></a> [internet\_gateway\_id](#input\_internet\_gateway\_id) | Specify an Internet Gateway ID to use. If not specified, a new Internet Gateway will be created. | `string` | `null` | no |
| <a name="input_key_pair"></a> [key\_pair](#input\_key\_pair) | Name of an existing Key Pair for AWS encryption | `string` | n/a | yes |
| <a name="input_lan_eni_primary_ip"></a> [lan\_eni\_primary\_ip](#input\_lan\_eni\_primary\_ip) | Choose an IP Address within the LAN Subnet for the Primary lan interface. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_lan_eni_secondary_ip"></a> [lan\_eni\_secondary\_ip](#input\_lan\_eni\_secondary\_ip) | Choose an IP Address within the LAN Subnet for the Secondary lan interface. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_license_bw"></a> [license\_bw](#input\_license\_bw) | The license bandwidth number for the cato site, specifying bandwidth ONLY applies for pooled licenses.  For a standard site license that is not pooled, leave this value null. Must be a number greater than 0 and an increment of 10. | `string` | `null` | no |
| <a name="input_license_id"></a> [license\_id](#input\_license\_id) | The license ID for the Cato vSocket of license type CATO\_SITE, CATO\_SSE\_SITE, CATO\_PB, CATO\_PB\_SSE.  Example License ID value: 'abcde123-abcd-1234-abcd-abcde1234567'.  Note that licenses are for commercial accounts, and not supported for trial accounts. | `string` | `null` | no |
| <a name="input_mgmt_eni_primary_ip"></a> [mgmt\_eni\_primary\_ip](#input\_mgmt\_eni\_primary\_ip) | Choose an IP Address within the Management Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_mgmt_eni_secondary_ip"></a> [mgmt\_eni\_secondary\_ip](#input\_mgmt\_eni\_secondary\_ip) | Choose an IP Address within the Management Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Choose a unique range for your new vsocket site that does not conflict with the rest of your Wide Area Network.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the vsocket site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | The Location of the Site | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | n/a | yes |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the vsocket site | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_subnet_range_lan_primary"></a> [subnet\_range\_lan\_primary](#input\_subnet\_range\_lan\_primary) | Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /29.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_lan_secondary"></a> [subnet\_range\_lan\_secondary](#input\_subnet\_range\_lan\_secondary) | Choose a range within the VPC to use as the Private/LAN subnet. This subnet will host the target LAN interface of the vSocket so resources in the VPC (or AWS Region) can route to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /29.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_mgmt_primary"></a> [subnet\_range\_mgmt\_primary](#input\_subnet\_range\_mgmt\_primary) | Choose a range within the VPC to use as the Management subnet. This subnet will be used initially to access the public internet and register your vSocket to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_mgmt_secondary"></a> [subnet\_range\_mgmt\_secondary](#input\_subnet\_range\_mgmt\_secondary) | Choose a range within the VPC to use as the Management subnet. This subnet will be used initially to access the public internet and register your vSocket to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_tgw_primary"></a> [subnet\_range\_tgw\_primary](#input\_subnet\_range\_tgw\_primary) | Choose a range within the VPC to use as the Transit Gateway subnet. This subnet will be used to house the endpoints used by the transit gateway in Primary AZ<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_tgw_secondary"></a> [subnet\_range\_tgw\_secondary](#input\_subnet\_range\_tgw\_secondary) | Choose a range within the VPC to use as the Transit Gateway subnet. This subnet will be used to house the endpoints used by the transit gateway in Secondary AZ<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_wan_primary"></a> [subnet\_range\_wan\_primary](#input\_subnet\_range\_wan\_primary) | Choose a range within the VPC to use as the Public/WAN subnet. This subnet will be used to access the public internet and securely tunnel to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_subnet_range_wan_secondary"></a> [subnet\_range\_wan\_secondary](#input\_subnet\_range\_wan\_secondary) | Choose a range within the VPC to use as the Public/WAN subnet. This subnet will be used to access the public internet and securely tunnel to the Cato Cloud.<br/>    The minimum subnet length to support High Availability is /28.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be appended to AWS resources | `map(string)` | `{}` | no |
| <a name="input_tgw_id"></a> [tgw\_id](#input\_tgw\_id) | Specify the Transit Gateway ID to use.  We will attach a new VPC to this transit gateway with a vSocket in it, and set the default (0.0.0.0/0) route to point at this new VPC. | `string` | n/a | yes |
| <a name="input_tgw_route_table_id"></a> [tgw\_route\_table\_id](#input\_tgw\_route\_table\_id) | Specify the Transit Gateway Route Table to use.  This is where the 0.0.0.0/0 route will be set. | `string` | n/a | yes |
| <a name="input_token"></a> [token](#input\_token) | Cato API token | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Specify a VPC ID to use. If not specified, a new VPC will be created. | `string` | `null` | no |
| <a name="input_vpc_network_range"></a> [vpc\_network\_range](#input\_vpc\_network\_range) | Choose a unique range for your new vpc where the vSocket will live.<br/>    The accepted input format is Standard CIDR Notation, e.g. X.X.X.X/X | `string` | n/a | yes |
| <a name="input_wan_eni_primary_ip"></a> [wan\_eni\_primary\_ip](#input\_wan\_eni\_primary\_ip) | Choose an IP Address within the Public/WAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |
| <a name="input_wan_eni_secondary_ip"></a> [wan\_eni\_secondary\_ip](#input\_wan\_eni\_secondary\_ip) | Choose an IP Address within the Public/WAN Subnet. You CANNOT use the first four assignable IP addresses within the subnet as it's reserved for the AWS virtual router interface. The accepted input format is X.X.X.X | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_availability_zones_out"></a> [aws\_availability\_zones\_out](#output\_aws\_availability\_zones\_out) | List of availability zones used for this deployment |
| <a name="output_aws_iam_instance_profile_name"></a> [aws\_iam\_instance\_profile\_name](#output\_aws\_iam\_instance\_profile\_name) | Name of the IAM instance profile assigned to vSocket EC2 instances |
| <a name="output_aws_iam_policy_arn"></a> [aws\_iam\_policy\_arn](#output\_aws\_iam\_policy\_arn) | ARN of the IAM policy attached to the HA role |
| <a name="output_aws_iam_role_name"></a> [aws\_iam\_role\_name](#output\_aws\_iam\_role\_name) | Name of the IAM role granting vSocket HA permissions |
| <a name="output_aws_instance_primary_vsocket_id"></a> [aws\_instance\_primary\_vsocket\_id](#output\_aws\_instance\_primary\_vsocket\_id) | Instance ID of the primary vSocket EC2 |
| <a name="output_aws_instance_secondary_vsocket_id"></a> [aws\_instance\_secondary\_vsocket\_id](#output\_aws\_instance\_secondary\_vsocket\_id) | Instance ID of the secondary vSocket EC2 |
| <a name="output_cato_license_site"></a> [cato\_license\_site](#output\_cato\_license\_site) | Metadata for the Cato license and site when a license ID is supplied |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | Internet Gateway ID (existing or newly created) attached to the VPC |
| <a name="output_lan_eni_primary_id"></a> [lan\_eni\_primary\_id](#output\_lan\_eni\_primary\_id) | LAN ENI ID providing internal LAN access to the first vSocket |
| <a name="output_lan_eni_secondary_id"></a> [lan\_eni\_secondary\_id](#output\_lan\_eni\_secondary\_id) | LAN ENI ID providing internal LAN access to the standby vSocket |
| <a name="output_lan_route_table_id"></a> [lan\_route\_table\_id](#output\_lan\_route\_table\_id) | Route table ID associated with the LAN subnets |
| <a name="output_lan_subnet_primary_azid"></a> [lan\_subnet\_primary\_azid](#output\_lan\_subnet\_primary\_azid) | Primary LAN subnet ID serving internal applications |
| <a name="output_lan_subnet_primary_id"></a> [lan\_subnet\_primary\_id](#output\_lan\_subnet\_primary\_id) | Primary LAN subnet ID serving internal applications |
| <a name="output_lan_subnet_route_table_id"></a> [lan\_subnet\_route\_table\_id](#output\_lan\_subnet\_route\_table\_id) | The ID of the LAN Subnet Route Table |
| <a name="output_lan_subnet_secondary_azid"></a> [lan\_subnet\_secondary\_azid](#output\_lan\_subnet\_secondary\_azid) | Secondary LAN subnet ID providing HA for internal traffic |
| <a name="output_lan_subnet_secondary_id"></a> [lan\_subnet\_secondary\_id](#output\_lan\_subnet\_secondary\_id) | Secondary LAN subnet ID providing HA for internal traffic |
| <a name="output_mgmt_eni_primary_id"></a> [mgmt\_eni\_primary\_id](#output\_mgmt\_eni\_primary\_id) | Management ENI ID attached to the first vSocket instance |
| <a name="output_mgmt_eni_secondary_id"></a> [mgmt\_eni\_secondary\_id](#output\_mgmt\_eni\_secondary\_id) | Management ENI ID attached to the standby vSocket instance |
| <a name="output_mgmt_subnet_primary_id"></a> [mgmt\_subnet\_primary\_id](#output\_mgmt\_subnet\_primary\_id) | Subnet ID dedicated to management traffic for vSockets |
| <a name="output_mgmt_subnet_secondary_id"></a> [mgmt\_subnet\_secondary\_id](#output\_mgmt\_subnet\_secondary\_id) | Subnet ID dedicated to management traffic for vSockets |
| <a name="output_mgmteip_primary"></a> [mgmteip\_primary](#output\_mgmteip\_primary) | Public IP address of the primary management Elastic IP |
| <a name="output_mgmteip_secondary"></a> [mgmteip\_secondary](#output\_mgmteip\_secondary) | Public IP address of the secondary management Elastic IP |
| <a name="output_sg_external"></a> [sg\_external](#output\_sg\_external) | ID of the external security group that governs Internet‑facing traffic |
| <a name="output_sg_internal"></a> [sg\_internal](#output\_sg\_internal) | ID of the internal security group that controls traffic for vSockets |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | The ID of the Transit Gateway |
| <a name="output_transit_gateway_primary_subnet_cidr"></a> [transit\_gateway\_primary\_subnet\_cidr](#output\_transit\_gateway\_primary\_subnet\_cidr) | The CIDR of the primary subnet of the Cato VPC |
| <a name="output_transit_gateway_primary_subnet_id"></a> [transit\_gateway\_primary\_subnet\_id](#output\_transit\_gateway\_primary\_subnet\_id) | The ID of the primary subnet of the Cato VPC |
| <a name="output_transit_gateway_routetable_id"></a> [transit\_gateway\_routetable\_id](#output\_transit\_gateway\_routetable\_id) | The ID of the Transit Gateway Route Table |
| <a name="output_transit_gateway_secondary_subnet_cidr"></a> [transit\_gateway\_secondary\_subnet\_cidr](#output\_transit\_gateway\_secondary\_subnet\_cidr) | The CIDR of the secondary subnet of the Cato VPC |
| <a name="output_transit_gateway_secondary_subnet_id"></a> [transit\_gateway\_secondary\_subnet\_id](#output\_transit\_gateway\_secondary\_subnet\_id) | The ID of the secondary subnet of the Cato VPC |
| <a name="output_transit_gateway_vpc_attachment_id"></a> [transit\_gateway\_vpc\_attachment\_id](#output\_transit\_gateway\_vpc\_attachment\_id) | The Attachment ID of the attachment of the Cato VPC to the Transit Gateway |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID (existing or newly created) hosting the vSocket resources |
| <a name="output_wan_eni_primary_id"></a> [wan\_eni\_primary\_id](#output\_wan\_eni\_primary\_id) | WAN ENI ID for outbound Internet connectivity on the first vSocket |
| <a name="output_wan_eni_secondary_id"></a> [wan\_eni\_secondary\_id](#output\_wan\_eni\_secondary\_id) | WAN ENI ID for outbound Internet connectivity on the standby vSocket |
| <a name="output_wan_route_table_id"></a> [wan\_route\_table\_id](#output\_wan\_route\_table\_id) | Route table ID associated with the WAN subnet |
| <a name="output_wan_subnet_primary_id"></a> [wan\_subnet\_primary\_id](#output\_wan\_subnet\_primary\_id) | Subnet ID dedicated to WAN traffic for vSockets |
| <a name="output_wan_subnet_secondary_id"></a> [wan\_subnet\_secondary\_id](#output\_wan\_subnet\_secondary\_id) | Subnet ID dedicated to WAN traffic for vSockets |
| <a name="output_waneip_primary"></a> [waneip\_primary](#output\_waneip\_primary) | Public IP address of the primary WAN Elastic IP |
| <a name="output_waneip_secondary"></a> [waneip\_secondary](#output\_waneip\_secondary) | Public IP address of the secondary WAN Elastic IP |
<!-- END_TF_DOCS -->