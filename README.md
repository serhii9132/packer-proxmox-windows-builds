## packer-windows-proxmox-builds

This repository contains configuration files for a fully unattended installation of the following operating systems:
- Windows Server 2022 Standart (Desktop) Evaluation
- Windows Server 2025 Standart (Desktop) Evaluation
- Windows 11 Evaluation

### Template details:
- CPU: 4 cores/1 socket, host mode
- Disk: 100 Gb, qcow2
- RAM: 6 Gb
- SCSI controller: virtio-scsi-single
- Firmware: EFI
- Network adapter type: virtio
- Communicator: ssh or winrm

### Note
It is assumed that the Windows Evaluation ISO images and the virtio drivers have already been uploaded to the Proxmox repository under the following names:
- virtio-win.iso
- server-22-eval-eng.iso
- server-25-eval-eng.iso
- win-11-eval-eng.iso

### Usage
1. Create a local.pkrvars.hcl file in the project root directory with the following content:
 ```sh
pve_node_name=pve
pve_url=https://10.10.10.10:8006/api2/json
pve_username=root@pam!packer
pve_token=1111111111-2222-3333-a0de-a93224fdfsds
net_bridge=vmbr1
storage_pool_disks=local2

communicator=ssh # or winrm

winrm_password=Password1111

ssh_pub_key='"ssh-rsa AAAAB3NzaC1yc2EA...... "'
ssh_private_key_file=/path/to/key/
 ```
 
2. Run the following commands:
```sh
make build server22
make build server25
make build win-11
```