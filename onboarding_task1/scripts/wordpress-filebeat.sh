#!/bin/bash
#==================================================== WORDPRESS CONFIGURATION ===============================================================
sudo mkdir /mnt/wordpress
sudo chown heeheetraubuntu /mnt/wordpress
sudo sed -i "s/#user_allow_other/user_allow_other/g" /etc/fuse.conf
sudo -u heeheetraubuntu gcsfuse --implicit-dirs -o allow_other wordpressbucket2022task /mnt/wordpress
sudo ln -s /mnt/wordpress/wordpress /srv/www/ 
sudo chown -r www-data /mnt/wordpress
sudo a2ensite wordpress.conf
sudo systemctl reload apache2

#==================================================== FILEBEAT CONFIGURATION ===============================================================
elasticpass=$(gcloud secrets versions access latest --secret="elastic-password")
kibanaip=$(gcloud compute instances list --filter="name~'^kibana'" --format="list (INTERNAL_IP)" | cut -c 4-)
logstaship=$(gcloud compute instances list --filter="name~'^logstash'" --format="list (INTERNAL_IP)" | cut -c 4- | sed -E 's/^(.*)$/"\1:5044"/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/,/g')

cat << EOF > /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: filestream
  id: my-filestream-id
  enabled: false
  paths:
    - /var/log/*.log
filebeat.config.modules:
  path: /etc/filebeat/modules.d/*.yml
  reload.enabled: true
  reload.period: 10s
setup.kibana:
  host: "$kibanaip:5601"
  username: "elastic"
  password: "$elasticpass"
output.logstash:
  hosts: [$logstaship]
processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
EOF

cat << EOF > /etc/filebeat/modules.d/apache.yml.disabled
- module: apache
  access:
    enabled: true
    var.paths: ["/var/log/apache2/access.log*"]
  error:
    enabled: true
    var.paths: ["/var/log/apache2/error.log*"]
EOF
filebeat modules  enable apache
# filebeat setup --pipelines --modules apache
systemctl start filebeat.service