locals {
  admin_password = textencodebase64("${var.winrm_password}AdministratorPassword", "UTF-16LE")
  logon_password = textencodebase64("${var.winrm_password}Password", "UTF-16LE")

  cd_content = merge(
    {
      "/autounattend.xml" = templatefile("./${var.cd_label}/autounattend.xml.pkrtpl.hcl", {
        admin_password = local.admin_password
        logon_password = local.logon_password
        communicator   = var.communicator
      })
    },
    var.communicator == "ssh" ? {
      "/configure-ssh.ps1" = templatefile("../../provision/scripts/pre-build/configure-ssh.ps1.pkrtpl.hcl", {
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

variable "vm_name" {
    type = string
    default = "server-25"
}

variable "os_version" {
    type = string
    default = "win11"
}

variable "os_type" {
    type = string
    default = "win11"
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

variable "name_iso_virtio_drivers" {
    type = string
}

variable "boot_wait" {
    type = string
}

variable "boot_command" {
  type = list(string)
}