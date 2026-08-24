insecure_skip_tls_verify = true

storage_pool_disks = "local"
storage_pool_iso = "local"

cpu_type = "host"
cpu_cores = 4
cpu_sockets = 1
memory = 6144
scsi_controller = "virtio-scsi-single"
is_qemu_agent_enable = true

bus_type_dev = "virtio"
bus_type_cd_dev = "sata"

bios = "ovmf"

disk_size = "100G"
disk_format = "qcow2"
is_io_thread_enable = true

net_bridge = "vmbr0"
net_vlan_tag = ""

is_iso_unmount = true
cd_label = "cidata"
iso_virtio_drivers = "virtio-win.iso"

winrm_username = "Administrator"
winrm_timeout = "2h"
winrm_port = 5986
is_winrm_use_ssl = true
is_winrm_insecure = true

ssh_username = "Administrator"
ssh_timeout = "2h"

boot_wait = "2s"
boot_command = [
  "<enter><wait><enter><wait><enter><wait><enter><wait><enter><wait>",
  "<enter><wait><enter><wait><enter><wait><enter><wait><enter><wait>",
  "<enter><wait><enter><wait><enter><wait><enter><wait><enter><wait>"
]