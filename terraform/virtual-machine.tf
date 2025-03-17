resource "azurerm_public_ip" "openvpn_public_ip" {
  name                = "openvpn-public-ip"
  location            = azurerm_resource_group.openvpn_rg.location
  resource_group_name = azurerm_resource_group.openvpn_rg.name
  allocation_method   = "Static"
  tags = var.resource_tag
}

resource "azurerm_network_interface" "openvpn_ni" {
  name                = "openvpn-vm-ni"
  location            = azurerm_resource_group.openvpn_rg.location
  resource_group_name = azurerm_resource_group.openvpn_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.openvpn_public_ip.id
  }
  tags = var.resource_tag
}

resource "azurerm_linux_virtual_machine" "openvpn_vm" {
  name                  = "openvpn-vm"
  location              = azurerm_resource_group.openvpn_rg.location
  resource_group_name   = azurerm_resource_group.openvpn_rg.name
  size                  = var.vm_size
  admin_username        = "ubuntu"
  network_interface_ids = [azurerm_network_interface.openvpn_ni.id]
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file(var.public_key_path)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = var.resource_tag
}
