provider "vsphere" {
  user           = var.provider_user_name[terraform.workspace]
  password       = var.provider_password[terraform.workspace]
  vsphere_server = var.vsphere_server_name[terraform.workspace]

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = var.datacenter[terraform.workspace]
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = var.datastore_cluster[terraform.workspace]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool[terraform.workspace]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network[terraform.workspace]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "TEMPLATE_NAME IN YOUR VMWARE TEMPLATE FOLDER"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count = var.instance_count[terraform.workspace]
  name             = "${var.vm_name_prefix[terraform.workspace]}-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id
  folder           = var.vm_folder[terraform.workspace]
  num_cpus = var.num_of_cpus[terraform.workspace]
  memory   = var.memory_size[terraform.workspace]
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    
  }

  disk {
    label            = var.disk_label[terraform.workspace]
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.vm_name_prefix[terraform.workspace]}-${count.index + 1}"
        domain    = var.domain[terraform.workspace]
      }

      network_interface {
        ipv4_address = "${var.ipv4_address_prefix[terraform.workspace]}.${count.index + var.machine_name_start_index[terraform.workspace]}"
        ipv4_netmask = var.ipv4_net_mask[terraform.workspace]
      }

      ipv4_gateway = var.ipv4_gateway[terraform.workspace]
      dns_server_list = var.dns_server_list[terraform.workspace]
    }
  }
 #replace NEW_USER with the username you want
  provisioner "remote-exec" {
       inline = [
        "echo ${var.admin_password[terraform.workspace]} | sudo -S adduser --disabled-password --gecos '' NEW_USER",
        "sudo mkdir -p /home/NEW_USER/.ssh",
        "sudo touch /home/NEW_USER/.ssh/authorized_keys",
        "sudo echo '${var.NEW_USER_publickey[terraform.workspace]}' > authorized_keys",
        "sudo mv authorized_keys /home/NEW_USER/.ssh",
        "sudo chown -R NEW_USER:NEW_USER /home/NEW_USER/.ssh",
        "sudo chmod 700 /home/NEW_USER/.ssh",
        "sudo chmod 600 /home/NEW_USER/.ssh/authorized_keys",
        "echo 'ersinkaya ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers"
   ]

     connection{
      type      = "ssh"
      user      = var.admin_user_name[terraform.workspace]
      password  = var.admin_password[terraform.workspace]
      host      = self.default_ip_address
    }
  }
}
