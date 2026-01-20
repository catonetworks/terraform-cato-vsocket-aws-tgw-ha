# Changelog

## 0.0.1 (2025-05-19)

### Features
- Initial commit with single socket instance with 3 NICs, creating full vpc
- Requires 0.0.10 of catonetworks/vsocket-aws-ha-vpc/cato module

## 0.0.2 (2025-05-30)

### Features 
- Created Feature Flag for Default Route in TGW Creation to Enable Planned Migration. 

## 0.0.3 (2025-06-05)

### Features
- Fixed typo found in variables.tf

## 0.0.4 (2025-06-27)

### Breaking Changes
- **REMOVED**: `var.native_network_range` variable - native network range is now automatically derived from `subnet_range_mgmt_primary`
- **CHANGED**: `ingress_cidr_blocks` parameter renamed to `lan_ingress_cidr_blocks` in module call
- **CHANGED**: Route creation now uses `routed_networks` map instead of single `native_network_range`

### Features
- **NEW**: Added `var.region` parameter for AWS region specification
- **NEW**: Added `var.routed_networks` map for defining multiple routed networks behind the vSocket
- **IMPROVED**: Site location is now automatically derived from AWS region (can still be overridden)
- **IMPROVED**: Route creation now supports multiple destination networks via `routed_networks` map

### Updates
- **DEPENDENCIES**: Updated Terraform version requirement from `>= 0.13` to `>= 1.5`
- **DEPENDENCIES**: Updated AWS provider version requirement to `>= 5.98.0`
- **DEPENDENCIES**: Updated Cato provider version from `~> 0.0.23` to `~> 0.0.27`
- **MODULE**: Updated underlying vsocket module source reference
- **DOCUMENTATION**: Updated README.md with new variable usage examples

## 0.0.5 (2025-07-16)
 - Fix incorrect version syntax in module call

## 0.0.6 (2025-08-01)

### Features
 - Updated to use latest provider version 
  - Adjusted routed_networks call to include interface_index 
 - Version Lock to Provider version 0.0.38 or greater

## 0.0.7 (2026-01-20)

### Features
 - Added license id and bw to nested module. 

