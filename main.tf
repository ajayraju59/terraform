  provider "azurerm" {
  features {}
}
  module "module" {
      source = "./module"
      
  }
  # module "vm-extension" {
  #     source = "./tf-az-customscript-extn"
  #     # location = "East Asia"
  #     # resource_group_name = module.module.rgname
  #     instance_name = "prodpc1"
  #     virtual_machine_id = module.module.vmid
  #     elkparameter1 = "elk1"
  #     elkparameter2 = "elk2"
  #     elkparameter3 = "[\\\"dev-elasticsearch-vm-data-0:9300\\\"]"
  #     elkparameter4 = "ellk4"
  #     elkparameter5 = "ellk5"
  #     elkparameter6 = "ellk6"
  # }
#    module "app-insights" {
#       source = "./applicationInsights"
      
#       name = "testmy"
#       location = "East Asia"
#       resource_group_name = "FCS-Sandbox-0"
#       application_type = "web"
#       sampling_percentage = 2
#   }