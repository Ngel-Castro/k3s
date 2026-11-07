# data_disk

Formats and mounts a VM's second disk at `/var/lib/rancher`, before K3s installs, so containerd's
images and the local-path volumes (Harbor's registry data among them) live on their own disk and
can grow without touching the root disk.

Run it after `common` and before `k3s` / `k3s-agent` (see `platform/ansible/main.yml`).

## What it does

1. Does nothing unless `k3s_data_disk_gb` is above 0.
2. Finds the disk: `data_disk_device` if set; the disk labelled `k3s-data` (a re-run); Proxmox's second
   disk by its by-id name; otherwise the one blank whole disk. None found is a failure that says the
   VM was created without a data disk.
3. Puts ext4 on the whole disk (no partition table) with the label `k3s-data`. A disk that already holds
   another filesystem is refused, never reformatted. Running the role again after the disk was enlarged
   grows the filesystem online.
4. Refuses to mount over `/var/lib/rancher/k3s` when it already exists on the root disk.
5. Mounts it by UUID with `defaults,nofail` (recorded in `/etc/fstab`), and adds a drop-in
   `RequiresMountsFor=/var/lib/rancher` to `k3s.service` and `k3s-agent.service`, so a missing mount
   stops K3s instead of filling the root disk.

## Variables

| Variable | Default | |
|---|---|---|
| `k3s_data_disk_gb` | `0` | Size of the data disk in GB; `0` skips the role |
| `data_disk_mount` | `/var/lib/rancher` | Mount point |
| `data_disk_label` | `k3s-data` | Filesystem label |
| `data_disk_device` | empty | Disk to use; empty means find it |
| `data_disk_by_id` | `/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1` | Proxmox's name for the second disk |
| `data_disk_units` | `k3s`, `k3s-agent` | Units that require the mount |

## Tests

Molecule, with loop devices in place of the VM's disk (no Proxmox involved):

```
cd platform/ansible/roles/data_disk && molecule test
```

It converges twice (second run `changed=0`), checks the mount, label, fstab and drop-ins, refuses a disk
with another filesystem, a missing disk, no disk at all and existing K3s data, and grows the filesystem
after the loop device is enlarged. Needs Docker and loop devices on the Docker host.

Not covered: the by-id name on a real Proxmox VM, and the boot with the disk missing.
