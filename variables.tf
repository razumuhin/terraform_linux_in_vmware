
variable "admin_user_name"{
    type = map(string)
}

variable "admin_password"{
    type = map(string)
}

variable "provider_user_name"{
    type = map(string)
}

variable "provider_password"{
    type = map(string)
}

variable "vsphere_server_name"{
    type = map(string)
}

variable "instance_count"{
    type = map(number)
}

variable "ersinkaya_publickey" {
    type = map(string)
}

variable "datacenter" {
  type = map(string)
}

variable "datastore_cluster" {
  type = map(string)
}

variable "resource_pool" {
  type = map(string)
}

variable "network" {
  type = map(string)
}

variable "vm_name_prefix" {
  type = map(string)
}

variable "vm_folder" {
  type = map(string)
}

variable "num_of_cpus" {
  type = map(number)
}

variable "memory_size" {
  type = map(number)
}

variable "disk_label" {
  type = map(string)
}

variable "domain" {
  type = map(string)
}

variable "ipv4_address_prefix" {
  type = map(string)
}

variable "ipv4_net_mask" {
  type = map(number)
}

variable "ipv4_gateway" {
  type = map(string)
}

variable "dns_server_list" {
  type = map(list(string))
}
variable "host_name_prefix" {
  type = map(string)
}

variable "machine_name_start_index" {
  type = map(number)
}

variable "template_name" {
  type = map(string)
  
}
variable "second_disk_size" {
  type = map(number)
  
}
variable "all-category" {
  type = map(string)
}
variable "tag-all" {
  type = map(string)
}

