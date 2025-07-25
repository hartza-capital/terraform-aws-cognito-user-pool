#
# Cognito User Pool with Managed Login Branding
#
module "aws_cognito_user_pool" {
  source = "../../"

  user_pool_name = var.user_pool_name
  user_pool_tier = var.user_pool_tier

  alias_attributes         = ["email", "preferred_username"]
  auto_verified_attributes = ["email"]

  # User pool client configuration
  clients = [
    {
      name                 = "app-client-web"
      callback_urls        = ["https://example.com/callback"]
      logout_urls          = ["https://example.com/logout"]
      default_redirect_uri = "https://example.com/callback"
      read_attributes      = ["email", "email_verified"]

      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_flows                  = ["code"]
      allowed_oauth_scopes                 = ["email", "openid", "profile"]

      explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_USER_SRP_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
      ]

      supported_identity_providers = ["COGNITO"]
    }
  ]

  # Domain configuration
  domain = var.domain_name

  # Managed Login Branding configuration
  managed_login_branding_enabled = var.enable_branding
  managed_login_branding = var.enable_branding ? {
    "main" = {
      client_id = "app-client-web" # Reference client by name
      assets = [
        {
          bytes      = filebase64("${path.module}/assets/logo-light.svg")
          category   = "PAGE_HEADER_LOGO"
          color_mode = "LIGHT"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/logo-dark.svg")
          category   = "PAGE_HEADER_LOGO"
          color_mode = "DARK"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/logo-light.svg")
          category   = "FORM_LOGO"
          color_mode = "LIGHT"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/logo-dark.svg")
          category   = "FORM_LOGO"
          color_mode = "DARK"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/background.svg")
          category   = "PAGE_BACKGROUND"
          color_mode = "DYNAMIC"
          extension  = "SVG"
        },
      ]
      # Use AWS default values for styling, just custom assets
      use_cognito_provided_values = true
      return_merged_resources     = true
    }
  } : {}

  tags = var.tags
}


