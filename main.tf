provider "vsphere" {
  user           = var.user_name
  password       = var.password
  vsphere_server = var.vsphere_server_name

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = "VMWARE DATA CENTER NAME"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "VMWARE DATASTORE CLUSETER NAME"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "lun1" {
  name          = "VMWARE lun NAME IN YOUR VMWARE DATASTORE CLUSTER"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "RESORUCE PO0L NAME  "
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "NETWORK NAME IN YOUR VMWARE "
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "LINUX TEMPLATE NAME IN YOUR VMWARE "
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count = var.instance_count
  
  name             = "VMNAME -${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id
  folder           = "VMWARE FOLDER NAME"
  num_cpus = 1
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "HOSTNAME-${count.index + 1}"
        domain    = "DOMAIN_NAME"
      }

        network_interface {
      ipv4_address = "IP${count.index + 11}"
      ipv4_netmask = 22
         }
    ipv4_gateway = "GAYEWAY"
    dns_server_list = [ "DNS_IP","DNS_IP2" ]
    }
  }
     provisioner "remote-exec" {
        inline = [
        "echo ${var.admin_password} | sudo -S adduser --disabled-password --gecos '' NEWUSER",
        "sudo mkdir -p /home/NEWUSER/.ssh",
        "sudo touch /home/NEWUSER/.ssh/authorized_keys",
        "sudo echo '${var.NEWUSER_publickey}' > authorized_keys",
        "sudo mv authorized_keys /home/NEWUSER/.ssh",
        "sudo chown -R NEWUSER:NEWUSER /home/NEWUSER/.ssh",
        "sudo chmod 700 /home/NEWUSER/.ssh",
        "sudo chmod 600 /home/NEWUSER/.ssh/authorized_keys",
        "echo 'NEWUSER ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers"
   ]

     connection{
      type      = "ssh"
      user      = var.admin_user_name
      password  = var.admin_password
      host      = self.default_ip_address
    }
  }
}

