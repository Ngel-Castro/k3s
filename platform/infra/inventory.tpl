all:
    hosts:
%{ for idx, vm in jsondecode(vms_inventory) ~}
        ${vm.name}:
            ansible_host: "${vm.ip}"
            ansible_user: "root"
            platform_environment: '{{ platform_environment }}'
%{ endfor ~}