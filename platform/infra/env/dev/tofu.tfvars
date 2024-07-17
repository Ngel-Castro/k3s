environment       = "dev"
vms = [
    { 
        name            = "k3s"
        target_node     = "proxmox"
        storage         = "Kingstone-data"
        storage_size    = 32
        full_clone      = true
        template_name   = "ubuntu-server-base"
        network_bridge  = "vmbr0"
        memory          = 6144
        cores           = 4
        tags            = "tofu;k3s"
    }
]