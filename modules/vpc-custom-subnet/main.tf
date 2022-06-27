################################################################################
# Custom subnet(s)
################################################################################

locals {
  private_custom_subnets = flatten([
    for block in var.private_custom_blocks : [
      for subnet in block.subnets : {
        subnet = subnet
        azs = block.azs
        subnet_suffix = block.subnet_suffix
        tags = block.tags
      }
    ]
  ])
}

resource "aws_subnet" "custom" {
  count = var.create_vpc && length(local.private_custom_subnets) > 0 ? length(local.private_custom_subnets) : 0

  vpc_id               = var.vpc_id
  cidr_block           = local.private_custom_subnets[count.index].subnet

  availability_zone    = length(regexall("^[a-z]{2}-", element(local.private_custom_subnets[count.index].azs, count.index))) > 0 ? element(local.private_custom_subnets[count.index].azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(local.private_custom_subnets[count.index].azs, count.index))) == 0 ? element(local.private_custom_subnets[count.index].azs, count.index) : null
  assign_ipv6_address_on_creation =  var.private_custom_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.private_custom_subnet_assign_ipv6_address_on_creation
  tags = merge(
    {
      "Name" = format(
        "${var.name}-${local.private_custom_subnets[count.index].subnet_suffix}-%s",
        element(local.private_custom_subnets[count.index].azs, count.index),
      )
    },
    var.tags,
    local.private_custom_subnets[count.index].tags,
  )
}

################################################################################
# Route table association
################################################################################

resource "aws_route_table_association" "custom_private" {
  count = var.create_vpc && length(local.private_custom_subnets) > 0 ? length(local.private_custom_subnets) : 0

  subnet_id = element(aws_subnet.custom[*].id, count.index)
  route_table_id = element(
    var.private_route_table_ids,
    var.single_nat_gateway ? 0 : count.index,
  )
}