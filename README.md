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
1. Create a .env file in the project root directory with the following content:
 ```sh
PKR_VAR_pve_node_name=pve
PKR_VAR_pve_url=https://10.10.10.10:8006/api2/json
PKR_VAR_pve_username=root@pam!packer
PKR_VAR_pve_token=1111111111-2222-3333-a0de-a93224fdfsds
PKR_VAR_net_bridge=vmbr1
PKR_VAR_storage_pool_disks=local2

PKR_VAR_communicator=ssh # or winrm

PKR_VAR_winrm_password=Password1111

PKR_VAR_ssh_pub_key='"ssh-rsa AAAAB3NzaC1yc2EA...... "'
PKR_VAR_ssh_private_key_file=/path/to/key/
 ```
 
2. Run the following commands:
```sh
make build server22
make build server25
make build win-11
```