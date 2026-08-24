locals {
  admin_password = textencodebase64("${var.winrm_password}AdministratorPassword", "UTF-16LE")
  logon_password = textencodebase64("${var.winrm_password}Password", "UTF-16LE")

  cd_content = merge(
    {
      "/autounattend.xml" = templatefile("${path.cwd}/autounattend/${var.vm_name}/autounattend.xml.pkrtpl.hcl", {
        admin_password = local.admin_password
        logon_password = local.logon_password
        communicator   = var.communicator
      })
    },
    var.communicator == "ssh" ? {
      "/configure-ssh.ps1" = templatefile("${path.cwd}/provision/scripts/pre-build/configure-ssh.ps1.pkrtpl.hcl", {
        pub_key = var.ssh_pub_key
      })
    } : {}
  )

  cd_files = concat(
    [
      abspath("${path.cwd}/provision/scripts/pre-build/install-virtio-drivers.ps1"),
    ],
    var.communicator == "winrm" ? [
      abspath("${path.cwd}/provision/scripts/pre-build/configure-winrm.ps1")
    ] : []
  )
}

variable "pve_url" {
    type = string
}

variable "insecure_skip_tls_verify" {
    type = bool
}

variable "pve_username" {
    type = string
}

variable "pve_token" {
    type = string
}

variable "pve_node_name" {
    type = string
}

variable "storage_pool_iso" {
    type = string
}

variable "storage_pool_disks" {
    type = string
}

variable "vm_name" {
    type = string
}

variable "os_version" {
    type = string
}

variable "os_type" {
    type = string
}

variable "cpu_type" {
    type = string
}

variable "cpu_cores" {
    type = number
}

variable "cpu_sockets" {
    type = number
}

variable "memory" {
    type = number
}

variable "scsi_controller" {
    type = string
}

variable "communicator" {
    type = string
}

variable "is_qemu_agent_enable" {
    type = bool
}

variable "bus_type_dev" {
    type = string
}

variable "bus_type_cd_dev" {
    type = string
}

variable "bios" {
    type = string
}

variable "is_tpm_enable" {
    type = bool
    description = "Enable TPM module (Windows 11 is required)"
    default = false
}

variable "disk_size" {
    type = string
}

variable "disk_format" {
    type = string
}

variable "is_io_thread_enable" {
    type = bool
}

variable "net_bridge" {
    type = string
}

variable "net_vlan_tag" {
    type = string
}

variable "is_iso_unmount" {
    type = bool
}

variable "cd_label" {
    type = string
}

variable "iso_windows_image" {
    type = string
}

variable "iso_virtio_drivers" {
    type = string
}

variable "boot_wait" {
    type = string
}

variable "boot_command" {
  type = list(string)
}

variable "ssh_username" {
    type = string
}

variable "ssh_timeout" {
    type = string
}

variable "ssh_private_key_file" {
    type = string
}

variable "ssh_pub_key" {
    type = string
}

variable "winrm_username" {
    type = string
}

variable "winrm_password" {
    type = string
}

variable "winrm_timeout" {
    type = string
}

variable "winrm_port" {
    type = number
}

variable "is_winrm_use_ssl" {
    type = bool
}

variable "is_winrm_insecure" {
    type = bool
}