terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9c054055-8ba1-4842-8ceb-3a8b8a12642f"
  client_id       = "a35a0c46-72ef-4801-aa7f-f706d9bc28cf"
  client_secret   = "a2P8Q~JmHq~f83GzJuzxak0Ilbd5bUyvIUYfUaLk"
  tenant_id       = "5f4cbced-a519-4f39-9137-7fec5594a76d"

}
