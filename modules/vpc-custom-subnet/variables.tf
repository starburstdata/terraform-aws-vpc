variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  type = object({
    Maintener = string
    Author    = string
  })
  description = "Define general tags"
}

variable "private_custom_blocks" {
  type        = map(any)
  description = "Define custom blocks"
  default     = {}
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Define private route table ids"
  default = []
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used"
  type        = string
  default     = null
}

variable "private_custom_subnet_assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on private custom subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = null
}

variable "assign_ipv6_address_on_creation" {
  description = "Assign IPv6 address on subnet, must be disabled to change IPv6 CIDRs. This is the IPv6 equivalent of map_public_ip_on_launch"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}