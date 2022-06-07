variable location {
  default = "East Asia"
}

variable "resource_group_name" {
  default = "FCS-Sandbox"
  
}

variable address_space {
  type = list
  default = ["10.3.0.0/24"]
}

# variable address_prefix {
#   type = list
#   default = "10.16.1.0/24"
# }


variable address_prefix {
  type = list
  default = ["10.3.0.0/28"]
}


