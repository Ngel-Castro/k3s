module "vm_qemu" {
  source = "github.com/Ngel-Castro/vm_qemu_multiple?ref=0.0.3"

  # Pass in required variables
    proxmox_host            = var.proxmox_host
    proxmox_token_id        = var.proxmox_token_id
    proxmox_token_secret    = var.proxmox_token_secret
    vms                     = var.vms
    environment             = var.environment
}

data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")

  vars = {
    vms_inventory = local.vm_inventory_json
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory_${var.environment}.yaml"
  content  = data.template_file.inventory.rendered
}