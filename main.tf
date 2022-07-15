terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}  

terraform {
    backend "azurerm" {
        resource_group_name  = "tf_blobstorage_rg"
        storage_account_name = "tfstoragebdorobek"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

# variable "imagebuild" {
#   type        = string
#   description = "Latest Image Build"
# }

resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "West Europe"
}

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type     = "Public"
  dns_name_label      = "bdorobek"
  os_type             = "Linux"

  container {
    name   = "weatherapi"
    image  = "bdorobek/weatherapi"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}