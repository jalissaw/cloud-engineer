# Azure Staging Deployment Configuration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Reference your existing Azure Container Registry in demo-rg
data "azurerm_container_registry" "existing_acr" {
  name                = "regd1"
  resource_group_name = "demo-rg" 
}

# 2. Create the container hosting environment
resource "azurerm_container_app_environment" "env" {
  name                = "cae-staging"
  resource_group_name = data.azurerm_container_registry.existing_acr.resource_group_name
  location            = data.azurerm_container_registry.existing_acr.location
}

# 3. Create the Container App to host your Flask site
resource "azurerm_container_app" "staging" {
  name                         = "simple-flask-app-staging"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = data.azurerm_container_registry.existing_acr.resource_group_name
  revision_mode                = "Single"

  registry {
    server               = data.azurerm_container_registry.existing_acr.login_server
    username             = data.azurerm_container_registry.existing_acr.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = data.azurerm_container_registry.existing_acr.admin_password
  }

  template {
    container {
      name   = "flask-container"
      image  = "${data.azurerm_container_registry.existing_acr.login_server}/simple-flask-app:latest"
      cpu    = "0.25"
      memory = "0.5Gi"
    }
  }
}

# 4. Output your live website URL
output "service_url" {
  value = azurerm_container_app.staging.latest_revision_fqdn
}
