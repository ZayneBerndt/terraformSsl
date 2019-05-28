resource "azurerm_resource_group" "demo" {
  name     = "demo-resource-group"
  location = "East US"
}

resource "azurerm_app_service_plan" "demo" {
  name                = "demo-app-service-plan"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "demo" {
  name                = "demo-app-service"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  app_service_plan_id = "${azurerm_app_service_plan.demo.id}"
}

resource "azurerm_app_service_custom_hostname_binding" "demo" {
  hostname            = "www.zayneberndt.com"
  app_service_name    = "${azurerm_app_service.demo.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
}

resource "null_resource" "azure-cli" {
  
  provisioner "local-exec" {
    command = "ssl-script.sh"

    environment {
      webappname = "${azurerm_app_service.demo.name}"
      resourceGroup = ${azurerm_resource_group.demo.name}
    }
  }

  depends_on = ["azurerm_app_service_custom_hostname_binding.demo"]
}