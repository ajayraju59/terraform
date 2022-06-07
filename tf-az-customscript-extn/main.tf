provider "azurerm" {
  features {}
}

resource "azurerm_virtual_machine_extension" "couchbasecluster" {
  name                 = "clusterNode-${var.instance_name}"
#   location             = var.location
#   resource_group_name  = var.resource_group_name
#   virtual_machine_name = var.instance_name
  virtual_machine_id   = var.virtual_machine_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings = <<SETTINGS
    {
      "commandToExecute": "sh elk-final.sh ${var.elkparameter1} ${var.elkparameter2} ${var.elkparameter3} ${var.elkparameter4} ${var.elkparameter5} ${var.elkparameter6}"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "fileUris": ["https://fcstestsa1.blob.core.windows.net/mytest/elk-final.sh"]
    }
  PROTECTED_SETTINGS
}