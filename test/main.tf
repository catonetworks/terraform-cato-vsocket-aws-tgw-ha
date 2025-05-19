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
  source                      = "../"
  token                       = var.token
  account_id                  = var.account_id
  vpc_id                      = null
  internet_gateway_id         = null
  key_pair                    = "test-keypair"
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
  tgw_id                      = "tgw-0247c82000e7c4b08"
  tgw_route_table_id          = "tgw-rtb-0fbaa4a7846c45c25"
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