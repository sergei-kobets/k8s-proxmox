# k8s-proxmox
Provision a clean Kubernetes (K8s) cluster on Proxmox VE using Infrastructure as Code (IaC).
The setup uses Debian Bookworm cloud-init images running in Proxmox virtual machines, managed with Terraform and Ansible.

## Requirements
- A control machine with:
  - Ansible installed
  - Terraform installed
- An on-prem Proxmox VE server running on bare metal
- A Proxmox API token with the required permissions
- A Debian-based cloud-init VM template named "vmtemp"
- If the name is different, you must update the Terraform configuration
- An OpenSSH private key file named "p_key" placed in the project root directory
- The VM IP addresses must be adjusted to match your private network setup. This project assumes a default subnet of 192.168.178.0/24. Review and update IPs in the Terraform and Ansible configuration files as needed..
- The following environment variables must be exported in your shell (or added to .bashrc):
```bash
export TF_VAR_ssh_user="your_vm_username"
export TF_VAR_pm_api_token_id="your_token_id"
export TF_VAR_pm_api_token_secret="your_token_secret"
export TF_VAR_pm_api_url="https://<proxmox_ip>:8006/api2/json"
export TF_VAR_ssh_pub_key="your_public_ssh_key"
```

## Usage
- Navigate to the "terraform" directory and run the following command:
```bash
terraform apply
```
This will create one Kubernetes master node and three worker nodes.
SSH access is configured using the provided private key. Password authentication is disabled.

- Navigate to the "ansible" directory and run:
```bash
ansible-playbook setup.yaml -i inventory.yaml
```
This installs required system dependencies and prepares the VMs for Kubernetes.

- To set up the Kubernetes control plane on the master node, run:
```bash
ansible-playbook master-setup.yaml -i inventory.yaml
```
This installs Kubernetes on the master node and creates a file named "creds" containing the token used for joining worker nodes.
Do not modify or delete the "creds" file.

- To configure and join the worker nodes to the cluster, run:
```bash
ansible-playbook node-setup.yaml -i inventory.yaml
```
Your Kubernetes cluster is now ready for use.

## Additional Notes
All commands must be run in the correct sequence for a successful setup.
Adjust usernames, IP addresses, tokens, and keys to match your environment.
Tested using Debian Bookworm cloud-init images on Proxmox VE.
