# k3s

Terraform + Ansible automation to provision a K3s cluster.

## Repository layout

```
platform/
  infra/          # Terraform/OpenTofu for VM infrastructure
  ansible/
    roles/
      common/     # Base OS setup
      k3s/        # K3s server role
      k3s-agent/  # K3s agent role
    inventory/
    main.yml
```

## Running Molecule tests locally

### Prerequisites

```bash
pip install ansible molecule molecule-plugins[docker] docker yamllint ansible-lint
```

Docker must be running on your workstation.

### Test the k3s-agent role

```bash
cd platform/ansible/roles/k3s-agent
molecule test
```

`molecule test` runs the full lifecycle: create → converge → idempotency → verify → destroy.

To run individual stages:

```bash
molecule converge   # provision and apply the role
molecule verify     # run the verify playbook assertions
molecule idempotency  # check that a second converge makes no changes
molecule destroy    # remove the test container
```

### Test the k3s (server) role

```bash
cd platform/ansible/roles/k3s
molecule test
```

## Linting

```bash
# From the repo root
yamllint platform/ansible/
ansible-lint platform/ansible/
```

## CI

GitHub Actions runs `yamllint`, `ansible-lint`, and `molecule test` for both roles on every push/PR that touches `platform/ansible/`. See [`.github/workflows/ansible-ci.yml`](.github/workflows/ansible-ci.yml).
