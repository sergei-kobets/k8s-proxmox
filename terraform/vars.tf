variable "ssh_user" {
    description = "cloud init user"
    sensitive = true
}

variable "ssh_pub_key" {
    description = "cloud init ssh pub key"
    sensitive = true
}

variable "pm_api_token_id" {
    description = "proxmox api token"
    sensitive = true
} 

variable "pm_api_token_secret" {
    description = "proxmox api secret"
    sensitive = true
}

variable "pm_api_url" {
    description = "proxmox api url"
    sensitive = true
}
