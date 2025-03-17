variable "public_key_path" {
  description = "Public key for VM access"
  default     = ""
}

variable "subscription_id" {
  description = "Your Azure subscription ID"
  default = ""
}

variable "vm_size" {
  description = "VM size"
  default     = "Standard_B1s"
}

variable "region" {
  description = "Resources' region"
  default     = "North Europe"
}

variable "resource_tag" {
  description = "The tag to apply to all resources"
  type        = map(string)
  default = {
    app = "openvpn"
  }
}
