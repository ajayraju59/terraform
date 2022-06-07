

provider "azurerm" {
  features {}
}


resource "azurerm_virtual_network" "new-network" {
name = "myfirstvnet"    
resource_group_name = "${azurerm_resource_group.myfirstproject[0].name}"
location = "${azurerm_resource_group.myfirstproject[0].location}"
address_space = var.address_space
  
}

resource "azurerm_resource_group" "myfirstproject" {
  name = "${var.resource_group_name}-${count.index}"
  location = var.location
  count  = length(var.address_prefix)
}
resource "azurerm_public_ip" "testpubip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = "${azurerm_resource_group.myfirstproject[0].name}"
  location            = "${azurerm_resource_group.myfirstproject[0].location}"
  allocation_method   = "Dynamic"
}

resource "azurerm_subnet" "myfirstsubnet" {
name = "mysubnet${count.index}"
resource_group_name = "${azurerm_resource_group.myfirstproject[0].name}"
virtual_network_name ="${azurerm_virtual_network.new-network.name}"
address_prefixes = [element(var.address_prefix, count.index)]
count = length(var.address_prefix)
}

resource "azurerm_subnet_network_security_group_association" "example" {
subnet_id = azurerm_subnet.myfirstsubnet[count.index].id
network_security_group_id = azurerm_network_security_group.fundsNSG.id
count = length(var.address_prefix)
}

resource "azurerm_network_security_group" "fundsNSG" {
  location = var.location
  name = "fundsrule"
  resource_group_name = "${azurerm_resource_group.myfirstproject[0].name}"
}

resource "azurerm_network_security_rule" "tfnetwork" {
  name = "TCPrule"
    access = "Allow"
    description = "DEV-rule"
    direction = "Inbound"
    destination_address_prefix = "*"
    destination_port_range = "443"
    priority = "1001"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
   resource_group_name = "${azurerm_resource_group.myfirstproject[0].name}"
   network_security_group_name = azurerm_network_security_group.fundsNSG.name

}
resource "azurerm_network_security_rule" "tfnetwork2" {
  name = "sshrule"
    access = "Allow"
    description = "DEV-rule"
    direction = "Inbound"
    destination_address_prefix = "*"
    destination_port_range = "22"
    priority = "1002"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
   resource_group_name = "${azurerm_resource_group.myfirstproject[0].name}"
   network_security_group_name = azurerm_network_security_group.fundsNSG.name
}
resource "azurerm_network_interface" "newinterface" {
  name = "prod-funds${count.index}"
  location = var.location
  resource_group_name = azurerm_resource_group.myfirstproject[0].name
  #virtual_network_name = azurerm_virtual_network.new-network.name
  count = length(var.address_prefix)
  ip_configuration {
    name = "my-config${count.index}"
    subnet_id = azurerm_subnet.myfirstsubnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.testpubip.id
  }

}

resource "azurerm_network_interface_security_group_association" "fcs-assiociation" {
  network_interface_id = azurerm_network_interface.newinterface[count.index].id
  network_security_group_id = azurerm_network_security_group.fundsNSG.id
  count = length(var.address_prefix)

}




# resource "azurerm_key_vault" "testmykey" {
#   name = "mychefkeytest"
#   location = var.location
#   resource_group_name = azurerm_resource_group.myfirstproject.name
#   sku_name = "standard"
#   tenant_id = "6f60f0b3-5f06-4e09-9715-989dba8cc7d8"
# }




# resource "azurerm_application_gateway" "FSC-gateway" {
#   enable_http2 = false
#   firewall_policy_id = "default"
#   name = "default"
#   resource_group_name = "value"
#   frontend_ip_configuration {
    
#   }
#   frontend_port {
    
#   }
#   http_listener {
    
#   }
#   sku {
    
#   }
#   backend_address_pool {
    
#   }
#   backend_http_settings {
    
#   }
#   waf_configuration {
    
#   }
# }
resource "azurerm_linux_virtual_machine" "name" {
 admin_password = "ajay@1234"
 admin_username = "ajay" 
 computer_name = "prodpc1"
 availability_set_id = azurerm_availability_set.avset.id
 disable_password_authentication = false
location = var.location
name = "prodmechine"
network_interface_ids = [azurerm_network_interface.newinterface[0].id]
  os_disk {
   caching = "ReadWrite"
#   disk_size_gb = 64
   storage_account_type = "Standard_LRS"
  }

resource_group_name = azurerm_resource_group.myfirstproject[0].name
size = "Standard_B2s"
source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }

}
output "public_ip_address" {
  value = azurerm_public_ip.testpubip.ip_address
}
resource "azurerm_managed_disk" "prodpcdisk" {
  name                 = "prodmechine-disk1"
  location             = azurerm_resource_group.myfirstproject[0].location
  resource_group_name  = azurerm_resource_group.myfirstproject[0].name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.prodpcdisk.id
  virtual_machine_id = azurerm_linux_virtual_machine.name.id
  lun                = "10"
  caching            = "ReadWrite"
}
resource "azurerm_availability_set" "avset" {
  name                = "vm-avset"
  location            = azurerm_resource_group.myfirstproject[0].location
  resource_group_name = azurerm_resource_group.myfirstproject[0].name
  platform_fault_domain_count = 2
  platform_update_domain_count = 5
}

output "vmid" {
  value = azurerm_linux_virtual_machine.name.id
}
output "rgname" {
  value = azurerm_resource_group.myfirstproject[0].name
}