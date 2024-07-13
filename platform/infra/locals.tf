locals {
  module_outputs  = {
    for k, v in module.vm_qemu.vm_vmids : k => {
      "id"   = v
      "ip"   = module.vm_qemu.vm_ips[k]
    }
  }

  vm_inventory = [
    for i, vm in var.vms : {
      name = vm.name
      id   = local.module_outputs[tostring(i)]["id"]
      ip   = replace(local.module_outputs[tostring(i)]["ip"], "/\\/\\d+$/", "")
    }
  ]
  vm_inventory_json = jsonencode(local.vm_inventory)
}
