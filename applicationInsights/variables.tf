variable "name" {
  description = "specifies the name of the application insights. Changing this forces a new resource tobe created"
}
variable "location" {
  description = "The location where the application insights resource is created. Changing this forces a new resource tobe created"
}
variable "resource_group_name" {
  description = "Resource group name that the application insights resource will be created in"
}
variable "application_type" {
  description = "Specifies the type of Application Insights to create. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created."
}
variable "sampling_percentage" {
 description = "Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry"  
}