packer {
  required_plugins {
    proxmox = {
      version = "1.2.3"
      source  = "github.com/hashicorp/proxmox"
    }
    windows-update = {
      version = "0.18.1"
      source  = "github.com/rgl/windows-update"
    }
  }
}

source "proxmox-iso" "windows" {
  proxmox_url               = var.pve_url
  insecure_skip_tls_verify  = var.insecure_skip_tls_verify
  username                  = var.pve_username
  token                     = var.pve_token
  node                      = var.pve_node_name

  vm_name                   = var.vm_name
  template_name             = "${var.vm_name}-tmp"
  os                        = var.os_version
  cpu_type                  = var.cpu_type
  cores                     = var.cpu_cores
  sockets                   = var.cpu_sockets
  memory                    = var.memory
  scsi_controller           = var.scsi_controller
  communicator              = var.communicator
  qemu_agent                = var.is_qemu_agent_enable

  bios                      = var.bios
  efi_config {
    efi_storage_pool        = var.storage_pool_disks
  }

  disks {
    storage_pool            = var.storage_pool_disks
    disk_size               = var.disk_size
    format                  = var.disk_format
    io_thread               = var.is_io_thread_enable
    type                    = var.bus_type_dev
  }

  network_adapters {
    model                   = var.bus_type_dev
    bridge                  = var.net_bridge
    vlan_tag                = var.net_vlan_tag == "" ? null : var.net_vlan_tag
  }

  boot_iso {
    type                    = var.bus_type_cd_dev
    unmount                 = var.is_iso_unmount
    iso_file                = "${var.storage_pool_iso}:iso/server-25-eval-eng.iso"
  }

  additional_iso_files { 
    type                    = var.bus_type_cd_dev
    index                   = 1
    cd_label                = var.cd_label
    cd_content              = local.cd_content
    cd_files                = local.cd_files
    iso_storage_pool        = var.storage_pool_iso
    unmount                 = var.is_iso_unmount
  }

  additional_iso_files { 
    type                    = var.bus_type_cd_dev
    index                   = 2
    iso_file                = "${var.storage_pool_iso}:iso/${var.name_iso_virtio_drivers}"
    unmount                 = var.is_iso_unmount
  }

  winrm_username            = var.winrm_username
  winrm_password            = var.winrm_password
  winrm_timeout             = var.winrm_timeout
  winrm_port                = var.winrm_port
  winrm_use_ssl             = var.is_winrm_use_ssl
  winrm_insecure            = var.is_winrm_insecure

  ssh_username              = var.ssh_username
  ssh_private_key_file      = var.ssh_private_key_file
  ssh_timeout               = var.ssh_timeout

  boot_wait                 = var.boot_wait
  boot_command              = var.boot_command
}

build {
  sources = ["source.proxmox-iso.windows"]

  provisioner "windows-restart" {}

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Driver*'",
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 10
  }

  provisioner "file" {
    content = templatefile("${path.cwd}/provision/configs/sysprep/server/unattend.xml.pkrtpl.hcl", {
      admin_password = local.admin_password
      logon_password = local.logon_password
    })
    destination = "C:/Windows/Panther/unattend.xml"
  }

  # Required because the 'file' provisioner cannot create remote directories
  provisioner "powershell" {
    inline = [
      "New-Item -ItemType Directory -Force -Path 'C:/Windows/Setup/Scripts'"
    ]
  }

  provisioner "file" {
    source  = "${path.cwd}/provision/scripts/sysprep/init-${var.communicator}.ps1"
    destination = "C:/Windows/Setup/Scripts/init-communicator.ps1"
  }

  provisioner "file" {
    source = "${path.cwd}/provision/scripts/sysprep/SetupComplete.cmd"
    destination = "C:/Windows/Setup/Scripts/SetupComplete.cmd"
  }
  
  provisioner "powershell" {
    scripts = [
      "${path.cwd}/provision/scripts/post-build/configure-services.ps1",
      "${path.cwd}/provision/scripts/post-build/cleanup.ps1"
    ]
    skip_clean = true
  }

  provisioner "powershell" {
    inline = [
      "Write-Host 'Running Sysprep'",
      "Start-Process -FilePath 'C:\\Windows\\system32\\Sysprep\\sysprep.exe' -ArgumentList '/generalize /oobe /quiet /quit /mode:vm' -NoNewWindow -Wait",
      "Remove-Item -Path $PSCommandPath -Force",
      "Remove-Item -Path 'C:\\Windows\\Temp\\packer-ps-env-vars-*' -Force"
    ]
    skip_clean = true
  }
}