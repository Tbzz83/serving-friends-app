# Static web app frontend
resource "azurerm_static_web_app" "app-ui" {
  name                = var.frontend_app_name
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  sku_tier            = var.static_app_sku_tier
  sku_size            = var.static_app_sku_size
  public_network_access_enabled = var.ui_public_access

  tags = {
    environment = var.tag
  }
}


# App service plan
resource "azurerm_service_plan" "app-plan" {
  name                = "app-plan-${var.tag}"
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.vm_sku

  tags = {
    environment = var.tag
  }
}

# Flask web app
resource "azurerm_linux_web_app" "app-api" {
  name                = var.backend_app_name
  resource_group_name = var.azurerm_resource_group.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app-plan.id

  # Disable when using private endpoint
  public_network_access_enabled = var.api_public_access 

  # Enable below for VNet integration
  virtual_network_subnet_id = var.api_app_subnet.id

  auth_settings_v2 {
    unauthenticated_action = "RedirectToLoginPage"
    auth_enabled = true
    forward_proxy_convention = "NoProxy"
    http_route_api_prefix = "/.auth"
    require_authentication = true
    require_https = true
    runtime_version = "~1"
    login {
      cookie_expiration_convention = "FixedTime"
      cookie_expiration_time = "08:00:00"
      nonce_expiration_time = "00:05:00"
      preserve_url_fragments_for_logins = false
      token_refresh_extension_time = 72
      token_store_enabled = false
      validate_nonce = true
    }

    azure_static_web_app_v2 {
      client_id = azurerm_static_web_app.app-ui.default_host_name 
    }
  }

  app_settings = {
    "WEBSITES_PORT" = "5000"
    "WEBSITE_WEBDEPLOY_USE_SCM" = true
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = 1
  }

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  tags = {
    environment = var.tag
  }
}

# Staging slot for API web app
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.app-api.id

  public_network_access_enabled = var.api_public_access

  # Enable below for VNet integration
  virtual_network_subnet_id = var.api_app_subnet.id

# We can leave out the auth settings for the staging slot so we can 
# verify our app is working by directly heading to <url>/api/friends
# If authentication is enabled like below then only the static web app can
# access our api
  
#  auth_settings_v2 {
#    unauthenticated_action = "RedirectToLoginPage"
#    auth_enabled = true
#    forward_proxy_convention = "NoProxy"
#    http_route_api_prefix = "/.auth"
#    require_authentication = true
#    require_https = true
#    runtime_version = "~1"
#    login {
#      cookie_expiration_convention = "FixedTime"
#      cookie_expiration_time = "08:00:00"
#      nonce_expiration_time = "00:05:00"
#      preserve_url_fragments_for_logins = false
#      token_refresh_extension_time = 72
#      token_store_enabled = false
#      validate_nonce = true
#    }
#
#    azure_static_web_app_v2 {
#      client_id = azurerm_static_web_app.app-ui.default_host_name 
#    }
#  }

  app_settings = {
    "WEBSITES_PORT" = "5000"
    "WEBSITE_WEBDEPLOY_USE_SCM" = true
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = 1
  }

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  tags = {
    environment = var.tag
  }
}
