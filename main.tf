

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "resourceGroup${environment}"
  location = "eastus"
}

resource "azurerm_application_insights" "appinsight" {
  name                = "appinsight${environment}assignment"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

output "instrumentation_key" {
  value     = azurerm_application_insights.appinsight.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.appinsight.app_id
}

resource "azurerm_container_registry" "acr" {
  name                = "containerRegistry${environment}assignment"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

output "acrname" {
  value = azurerm_container_registry.acr.name
}

output "acradminname" {
  value = azurerm_container_registry.acr.admin_username

}

output "acradminpass" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}
#Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appplan" {
  name                = "appplan${environment}assignment"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "B1"
    capacity = 1
  }
}

# Create the web app, pass in the App Service Plan IDs
# Define the Linux Web App
resource "azurerm_linux_web_app" "my_web_app" {
  name                = "springbootapp${environment}assignment"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_app_service_plan.appplan.id


  site_config {
    always_on = true
    # Specify your container image
  }


  app_settings = {
    "WEBSITES_PORT"                  = "8080"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.appinsight.instrumentation_key

  }
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "AutoscaleSetting"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_app_service_plan.appplan.id

  profile {
    name = "Weekends"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_app_service_plan.appplan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 90
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_app_service_plan.appplan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "2"
        cooldown  = "PT1M"
      }
    }

    recurrence {
      timezone = "UTC"
      days     = ["Saturday", "Sunday"]
      hours    = [12]
      minutes  = [0]
    }
  }
}