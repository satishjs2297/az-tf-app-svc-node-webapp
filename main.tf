# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "appservice-rg" {
  name     = var.rg-name
  location = var.rg-location
}

resource "azurerm_app_service_plan" "service-plan" {
  name = "tf-vig-service-plan"
  location = azurerm_resource_group.appservice-rg.location
  resource_group_name = azurerm_resource_group.appservice-rg.name
  kind = "Windows"
  reserved = false
  sku {
    tier = "Standard"
    size = "S1"
  }
  tags = {
    environment = var.environment
  }
}

resource "azurerm_app_service" "app-service" {
  name = "tf-vig-app-service"
  location = azurerm_resource_group.appservice-rg.location
  resource_group_name = azurerm_resource_group.appservice-rg.name
  app_service_plan_id = azurerm_app_service_plan.service-plan.id
  site_config {   
    windows_fx_version = "node|10.14"
  }
  tags = {
    environment = var.environment
  }
}
