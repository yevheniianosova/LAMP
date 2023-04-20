packer {
  required_plugins {
    googlecompute = {
      version = " >= 0.0.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "basic-example" {
    project_id = "${project_id}"
    source_image = "${source_image}"
    zone = "${zone}"
    network = "${network}"
    subnetwork = "${subnetwork}"
    ssh_username = "${ssh_username}"
    ssh_private_key_file = "${ssh_private_key_file}"
    ssh_bastion_host = "${ssh_bastion_host}"
    ssh_bastion_port = "${ssh_bastion_port}"
    ssh_bastion_username = "${ssh_bastion_username}"
    ssh_bastion_private_key_file = "${ssh_bastion_private_key_file}"
    use_internal_ip = true
    image_name= "${image_name}"
    tags = ["${tags}"]
    service_account_email= "${service_account_email}"
    scopes =["${scopes}"]
}
build {
    sources = ["sources.googlecompute.basic-example"]
    provisioner "ansible" {
    ansible_env_vars = [ "ANSIBLE_SSH_ARGS='-o PubkeyAcceptedKeyTypes=+ssh-rsa -o HostkeyAlgorithms=+ssh-rsa'"]
    extra_arguments =  ["--extra-vars", "${extravars}"]
    playbook_file   = "${playbook_file}" 
  }
}
