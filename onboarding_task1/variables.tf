variable "project" {
  type    = any
}
variable "region" {
  type    = string
}
variable "source_image" {
  type = any
}
variable "zone" {
  type = any
}
variable "network" {
  type = any
}
variable "subnetwork" {
  type = any
}
variable "ssh_username" {
  type = any
}
variable "ssh_private_key_file" {
  type = any
}
variable "ssh_bastion_port" {
  type = any
}
variable "ssh_bastion_username" {
  type = any
}
variable "ssh_bastion_private_key_file" {
  type = any
}
variable "wordpress_image_name" {
  type = any
}
variable "logstash_image_name" {
  type = any
}
variable "kibana_image_name" {
  type = any
}
variable "elastic_image_name" {
  type = any
}
variable "tags" {
  type = any
}
variable "wordpress_playbook_file" {
  type = any
}
variable "logstash_playbook_file" {
  type = any
}
variable "kibana_playbook_file" {
  type = any
}
variable "elastic_playbook_file" {
  type = any
}
variable "service_account_email" {
  type = any
}
variable "scopes" {
  type = any
}