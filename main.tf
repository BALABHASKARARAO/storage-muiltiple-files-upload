terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
  
      version = ">=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  
  features {}
}

#data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_storage_account" "example" {
  name                     = "bala12233sa"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "imges-folder"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "example" {
  for_each               = fileset(path.module, "file_uploads/*")
  name                   = trim(each.key, "file_uploads/")
  #count                 = length(var.user_names)
  #name                  = var.user_names[count.index]
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = "Block"
  #content_type           = "jpg"
  source                 = each.key
}
