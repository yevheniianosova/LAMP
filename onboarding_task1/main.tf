terraform {
  required_providers {
    packer = {
      source = "toowoxx/packer"
    }
    google = {}
  }
}
provider "packer" {}
provider "google" {
  project = var.project
  region  = var.region
}
module "dns" {
  source = "./modules/dns"
  domain = "heeheetra.pp.ua"
  region  = var.region
}

module "vpc" {
  source           = "./modules/vpc"
  vpc_network_name = "vpc-1"
  IP_range_public  = "10.0.1.0/24"
  IP_range_private = "10.0.2.0/24"
  bastion-static-ip = module.dns.bastion-static-ip
  vpc_public_subnet_name = "public-subnet"
  vpc_private_subnet_name = "private-subnet"
  region = var.region
}
module "secret_manager" {
  source = "./modules/secret_manager"
}
module "bucket" {
  source = "./modules/bucket"
  bucketname = "wordpressbucket2022task"
  location = var.region

  depends_on = [module.vpc]
}

module "IAMroles" {
  source   = "./modules/IAM_roles"
  bucketid = module.bucket.bucketid
  project  = var.project
  depends_on = [
    module.bucket
  ]
}

resource "random_password" "WPpass" {
  length           = 16
  special          = true
  override_special = "!#$"
}
resource "random_string" "WPname" {
  length           = 6
  lower          = true
  upper           = false
  special = false
  numeric  = false
}
resource "random_string" "WPuser" {
  length           = 6
  lower          = true
  upper           = false
  special = false
  numeric  = false
}

module "database" {
  source     = "./modules/database"
  network    = module.vpc.vpc_network
  db_name    = random_string.WPname.result
  db_user    = random_string.WPuser.result
  password   = random_password.WPpass.result
  region     = var.region  
  depends_on = [module.vpc]
}

resource "local_file" "wordpressimage_packer" {
  content = templatefile("/home/heeheetraubuntu/onboarding_task1/packer/template.tpl",{
    project_id = var.project
    source_image = var.source_image
    zone = var.zone
    network = var.network
    subnetwork = var.subnetwork
    ssh_username = var.ssh_username
    ssh_bastion_host = module.dns.bastion-static-ip
    ssh_bastion_port = var.ssh_bastion_port
    ssh_bastion_username = var.ssh_bastion_username
    ssh_private_key_file = var.ssh_private_key_file
    ssh_bastion_private_key_file = var.ssh_bastion_private_key_file
    image_name = var.wordpress_image_name
    playbook_file = var.wordpress_playbook_file
    tags = "${var.tags}"
    scopes = var.scopes
    service_account_email = var.service_account_email
    extravars = "DB_HOST_IP=${module.database.DB_HOST_IP} DB_HOST_NAME=${random_string.WPname.result} DB_HOST_USER=${random_string.WPuser.result}  DB_HOST_PASSWORD=${random_password.WPpass.result}"
  })
  filename =  "/home/heeheetraubuntu/onboarding_task1/packer/wordpress.pkr.hcl"
}

resource "local_file" "elasticimage_packer" {
  content = templatefile("/home/heeheetraubuntu/onboarding_task1/packer/template.tpl",{
    project_id = var.project
    source_image = var.source_image
    zone = var.zone
    network = var.network
    subnetwork = var.subnetwork
    ssh_username = var.ssh_username
    ssh_bastion_host = module.dns.bastion-static-ip
    ssh_bastion_port = var.ssh_bastion_port
    ssh_bastion_username = var.ssh_bastion_username
    ssh_private_key_file = var.ssh_private_key_file
    ssh_bastion_private_key_file = var.ssh_bastion_private_key_file
    image_name = var.elastic_image_name
    playbook_file = var.elastic_playbook_file
    tags = "${var.tags}"
    scopes = var.scopes
    service_account_email = var.service_account_email
    extravars = ""})
  filename =  "/home/heeheetraubuntu/onboarding_task1/packer/elastic.pkr.hcl"
}

resource "local_file" "logstashimage_packer" {
  content = templatefile("/home/heeheetraubuntu/onboarding_task1/packer/template.tpl",{
    project_id = var.project
    source_image = var.source_image
    zone = var.zone
    network = var.network
    subnetwork = var.subnetwork
    ssh_username = var.ssh_username
    ssh_bastion_host = module.dns.bastion-static-ip
    ssh_bastion_port = var.ssh_bastion_port
    ssh_bastion_username = var.ssh_bastion_username
    ssh_private_key_file = var.ssh_private_key_file
    ssh_bastion_private_key_file = var.ssh_bastion_private_key_file
    image_name = var.logstash_image_name
    playbook_file = var.logstash_playbook_file
    tags = "${var.tags}"
    scopes = var.scopes
    service_account_email = var.service_account_email
    extravars = ""})
  filename =  "/home/heeheetraubuntu/onboarding_task1/packer/logstash.pkr.hcl"
}

resource "local_file" "kibanaimage_packer" {
  content = templatefile("/home/heeheetraubuntu/onboarding_task1/packer/template.tpl",{
    project_id = var.project
    source_image = var.source_image
    zone = var.zone
    network = var.network
    subnetwork = var.subnetwork
    ssh_username = var.ssh_username
    ssh_bastion_host = module.dns.bastion-static-ip
    ssh_bastion_port = var.ssh_bastion_port
    ssh_bastion_username = var.ssh_bastion_username
    ssh_private_key_file = var.ssh_private_key_file
    ssh_bastion_private_key_file = var.ssh_bastion_private_key_file
    image_name = var.kibana_image_name
    playbook_file = var.kibana_playbook_file
    tags = "${var.tags}"
    scopes = var.scopes
    service_account_email = var.service_account_email
    extravars = ""})
  filename =  "/home/heeheetraubuntu/onboarding_task1/packer/kibana.pkr.hcl"
}
data "packer_version" "version" {}
resource "packer_image" "wordpressimage" {
  file = local_file.wordpressimage_packer.filename
  force     = true
  triggers = {
    packer_version = data.packer_version.version.version
  }  
  depends_on = [resource.local_file.wordpressimage_packer]
}
resource "packer_image" "elasticimage" {
  file = local_file.elasticimage_packer.filename
  force     = true
  triggers = {
    packer_version = data.packer_version.version.version
  } 
  depends_on = [resource.local_file.elasticimage_packer]
}
resource "packer_image" "logstashimage" {
  file = local_file.logstashimage_packer.filename
  force     = true
  triggers = {
    packer_version = data.packer_version.version.version
  }  
  depends_on = [resource.local_file.logstashimage_packer]
}
resource "packer_image" "kibanaimage" {
  file = local_file.kibanaimage_packer.filename
  force     = true
  triggers = {
    packer_version = data.packer_version.version.version
  }  
    depends_on = [resource.local_file.kibanaimage_packer]
}
module "elastic" {
  source              = "./modules/instances"
  serviceaccountemail = module.IAMroles.SAemail #add specific SA
  vpc_network_name    = module.vpc.vpc_network
  vpc_subnet_name     = module.vpc.vpc_private_subnet
  source_image        = "elasticimage"
  machine_type        = "e2-medium"
  instance_name       = "elasticsearch"
  tags                = ["elastic"]
  startup_script_path = file("~/onboarding_task1/scripts/elasticsearch-startup.sh")
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10
  region              = var.region
  quantity            = "3"
  depends_on          = [module.vpc, module.bucket,module.secret_manager,resource.packer_image.elasticimage]
  namedportname       = "elasticsearch"
  healthcheckport     = "9200"
}

resource "time_sleep" "wait" {
  depends_on = [module.elastic]
  create_duration = "500s"
}

resource "google_compute_instance" "kibana" {
  name         = "kibana-hkgd"
  machine_type = "e2-medium"
  zone         = "${var.region}-b"
  tags         = ["kibana", "elastic"]
  boot_disk {
    initialize_params {
     image = "kibanaimage-oauth2"
    }
  }
  network_interface {
    network    = module.vpc.vpc_network
    subnetwork = module.vpc.vpc_private_subnet
    access_config {
    nat_ip = "${module.dns.kibana-static-ip}"
    }
  }
  service_account {
    email  = module.IAMroles.SAemail
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = file("~/onboarding_task1/scripts/kibana-startup.sh")
  depends_on = [
    time_sleep.wait,module.dns,resource.packer_image.kibanaimage
  ]
}

resource "time_sleep" "waitkibana" {
  depends_on = [google_compute_instance.kibana]
  create_duration = "300s"
}

module "logstash" {
  source              = "./modules/instances"
  serviceaccountemail = module.IAMroles.SAemail #add specific SA
  vpc_network_name    = module.vpc.vpc_network
  vpc_subnet_name     = module.vpc.vpc_private_subnet
  source_image        = "logstashimage"
  machine_type        = "e2-medium"
  instance_name       = "logstash"
  tags                = ["logstash"]
  startup_script_path = file("~/onboarding_task1/scripts/logstash-startup.sh")
  check_interval_sec  = 300
  timeout_sec         = 300
  healthy_threshold   = 2
  unhealthy_threshold = 10
  region              = var.region
  quantity            = "2"
  depends_on          = [module.vpc,module.elastic,time_sleep.waitkibana,resource.packer_image.logstashimage]
  namedportname       = "logstash"
  healthcheckport     = "5044"
}

resource "time_sleep" "waitlogstash" {
  depends_on = [module.logstash]
  create_duration = "100s"
}

module "httpserver" {
  source              = "./modules/instances"
  serviceaccountemail = module.IAMroles.SAemail
  vpc_network_name    = module.vpc.vpc_network
  vpc_subnet_name     = module.vpc.vpc_private_subnet
  source_image        = "wordpress-filebeat-image"
  machine_type        = "e2-micro"
  instance_name       = "httpserver"
  tags                = ["httpserver"]
  startup_script_path = file("~/onboarding_task1/scripts/wordpress-filebeat.sh")
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10
  region              = var.region
  quantity            = "2"
  depends_on          = [module.vpc, module.bucket, module.database, resource.packer_image.wordpressimage]
  namedportname       = "http"
  healthcheckport     = "80"
}

module "loadbalancer" {
  source        = "./modules/loadbalancer"
  healthcheck   = module.httpserver.healthcheck
  instancegroup = module.httpserver.instancegroup
  SSLCert       = module.dns.SSLcert
  staticIP      = module.dns.lb-static-ip
  depends_on    = [module.vpc, module.httpserver]
}




