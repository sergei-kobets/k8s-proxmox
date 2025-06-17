resource "random_password" "k8s-master-password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "proxmox_vm_qemu" "k8s-master" {
  count = 1
  name = "k8s-master"
  target_node = "node1"
  clone = "vmtemp"
  memory = 5120
  agent = 1

  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  cpu {
    cores = 4
    sockets = 1
  }

  disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = 32
                    cache           = "writeback"
                    storage         = "local-lvm"
                    #storage_type    = "rbd"
                    #iothread        = true
                    #discard         = true
                    replicate       = true
                }
            }
        }
    }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  boot = "order=scsi0"

  ipconfig0 = "ip=192.168.178.230/24,gw=192.168.178.1"
  os_type = "cloud-init"
  vmid = 700

  ciuser = var.ssh_user
  sshkeys = var.ssh_pub_key
  cipassword = random_password.k8s-master-password.result

  serial {
      id   = 0
      type = "socket"
    }

  provisioner "remote-exec" {
    inline = [" sudo hostnamectl set-hostname k8s-master"]

    connection {
      host = self.ssh_host
      type = "ssh"
      user = var.ssh_user
      private_key = "${file("../p_key")}"
    }
  }
}
