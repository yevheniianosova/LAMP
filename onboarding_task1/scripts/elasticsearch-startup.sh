#!/bin/sh
set -e
gcloud secrets versions access latest --secret="elasticsearch-ca-crt" > /usr/share/elasticsearch/ca.crt
gcloud secrets versions access latest --secret="elasticsearch-ca-key" > /usr/share/elasticsearch/ca.key
gcloud secrets versions access latest --secret="elasticsearch-certificate-crt" > /etc/elasticsearch/elastic-certificate.crt
gcloud secrets versions access latest --secret="elasticsearch-certificate-key" > /etc/elasticsearch/elastic-certificate.key

echo "instances:
  - name: $(uname -n)
    ip:
      - $(hostname -I)" > /usr/share/elasticsearch/cert_info.yml

/usr/share/elasticsearch/bin/elasticsearch-certutil cert --silent --in cert_info.yml --pass "" --ca-cert ca.crt --ca-key ca.key --out "$(uname -n).zip"
(cd /etc/elasticsearch/ && unzip "/usr/share/elasticsearch/$(uname -n).zip")
#/usr/share/elasticsearch/bin/elasticsearch-certutil cert --silent --in cert_info.yml --pass "" --ca-cert ca.crt --ca-key ca.key 
#(cd /etc/elasticsearch/ && unzip /usr/share/elasticsearch/certificate-bundle.zip)
cp /usr/share/elasticsearch/ca.crt /etc/elasticsearch/ca.crt
INSTANCES_IP=$(gcloud compute instances list --filter="name~'^elasticsearch'" --format="list (INTERNAL_IP)" | cut -c 4- | sed -E 's/^(.*)$/"\1"/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/,/g')
INSTANCES_NAMES=$( gcloud compute instances list --filter='name ~ elasticsearch*' --format 'csv[no-heading](NAME)' | awk '{ printf "\"%s\", ", $0 }')
#$(gcloud compute instances list --filter="name~'^elasticsearch'" --format="config (NAME)" | cut -c 8- | sed -n '1 p')

echo "
cluster.name: elasticsearch-cluster
node.name:  $(uname -n) #$HOSTNAME
node.master: true
node.data: true
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
http.port: 9200
discovery.seed_hosts: [$INSTANCES_IP]
cluster.initial_master_nodes: [$INSTANCES_NAMES]
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.client_authentication: required
xpack.security.transport.ssl.key:  elastic-certificate.key
xpack.security.transport.ssl.certificate: elastic-certificate.crt
xpack.security.transport.ssl.certificate_authorities: ca.crt
xpack.security.http.ssl.enabled: true
# xpack.security.http.ssl.certificate: instance/instance.crt
# xpack.security.http.ssl.key: instance/instance.key
xpack.security.http.ssl.keystore.path: $(uname -n)/$(uname -n).p12
" > /etc/elasticsearch/elasticsearch.yml 

echo -Djava.net.preferIPv4Stack=true >> /etc/elasticsearch/jvm.options
systemctl start elasticsearch
systemctl enable elasticsearch 
