output "vm_public_ip" {
  value = azurerm_public_ip.openvpn_public_ip.ip_address
}