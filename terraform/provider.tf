# Provider configuration (provider.tf)
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

provider "proxmox" {
  # set in vars.tf 
  pm_api_url = var.pm_api_url

  # insecure unless using signed certificates
  pm_tls_insecure = true

  # token details
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret

}
