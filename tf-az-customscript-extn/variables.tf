# variable "location" {
#   description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
# }
# variable "resource_group_name" {
#   description = "A container that holds related resources for an Azure solution"
# }
variable "instance_name" {
  description = "The instance name of the VM"
}
variable "virtual_machine_id" {
  description = "Virtual machine id"
  default = ""
}

variable "elkparameter1" {
  description = "parameter1"
}

variable "elkparameter2" {
  description = "parameter2"
}

variable "elkparameter3" {
  description = "parameter3"
}

variable "elkparameter4" {
  description = "parameter4"
}

variable "elkparameter5" {
  description = "parameter5"
}

variable "elkparameter6" {
  description = "parameter6"
}