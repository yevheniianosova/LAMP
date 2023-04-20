variable "vpc_network_name" {
  type = string
}
variable "vpc_public_subnet_name" {
  type =any
}
variable "vpc_private_subnet_name" {
  type =any 
}
variable "region" {
  type = any
}
# variable "project_name" {
#     type = string
# }
# variable "vpc_subnet_name"{
#     type = string
# }
variable "IP_range_public" {
  type = any
}
variable "IP_range_private" {
  type = any
}
variable "bastion-static-ip"{
  type =any
}
# variable "isprivate"{
#     type = bool
# }
# variable "firewall_rule_name"{
#     type = string
# }
# variable "instance_name"{
#     type = string
# }

# variable "instance_zone"{
#     type = string
# }
