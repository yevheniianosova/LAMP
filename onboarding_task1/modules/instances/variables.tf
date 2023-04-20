variable "serviceaccountemail" {
  type = string
}
variable "check_interval_sec" {
  type    = any
  default = 5
}
variable "timeout_sec" {
  type    = any
  default = 5
}
variable "healthy_threshold" {
  type    = any
  default = 2
}
variable "unhealthy_threshold" {
  type    = any
  default = 10
}
variable "machine_type" {
  type    = any
  default = "e2-micro"
}

variable "source_image" {
  type    = any
  default = "packerimage"
}

variable "vpc_network_name" {
  type = any
}

variable "vpc_subnet_name" {
  type = any
}

variable "instance_name" {
  type = any

}
variable "region" {
  type = any
}
variable "quantity" {
  type    = any
  default = 1
}
variable "namedportname" {
  type = any
}
# variable "namedportport" {
#   type = any
# }
variable "tags" {
  type = any
}

variable "healthcheckport" {
  type = any
}
variable "startup_script_path" {
  type = any
}
# network = "vpc-1"##variable vpc_network_name
# subnetwork = "private-subnet" ## variable vpc_subnet_name