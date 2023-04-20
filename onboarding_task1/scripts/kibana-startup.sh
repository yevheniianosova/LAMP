#!/bin/bash
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

echo "
cluster.name: elasticsearch-cluster
node.name:  kibana
node.roles: [remote_cluster_client]
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
http.port: 9200
discovery.seed_hosts: [$INSTANCES_IP]
# cluster.initial_master_nodes: [$INSTANCES_NAMES]
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.client_authentication: required
xpack.security.transport.ssl.key:  elastic-certificate.key
xpack.security.transport.ssl.certificate: elastic-certificate.crt
xpack.security.transport.ssl.certificate_authorities: ca.crt
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: $(uname -n)/$(uname -n).p12
" > /etc/elasticsearch/elasticsearch.yml 


echo -Djava.net.preferIPv4Stack=true >> /etc/elasticsearch/jvm.options

ip=$(gcloud compute instances list --filter="name~'^elasticsearch'" --format="list (INTERNAL_IP)" | cut -c 4-)
cat << SCRIPT > /usr/share/elasticsearch/bin/https.sh
#!/usr/bin/expect -f
set timeout -1
spawn ./elasticsearch-certutil http -s
expect "Generate a CSR?"
send "n\n"
expect "Use an existing CA?"
send "y\n"
expect "CA Path:"
send "/usr/share/elasticsearch/ca.crt\n"
expect "CA Key:"
send "/usr/share/elasticsearch/ca.key\n"
expect "For how long should your certificate be valid?"
send "\n"
expect "Generate a certificate per node?"
send "n\n"
expect "## Which hostnames will be used to connect to your nodes?\r"
send "*.internal\n\n"
expect "Is this correct"
send "y\n"
expect "## Which IP addresses will be used to connect to your nodes?\r"
#expect "\#\#Which IP addresses will be used to connect to your nodes?\n"
send "$ip\n\n"
expect "Is this correct"
send "y\n"
expect "Do you wish to change any of these options?"
send "n\n"
expect "Provide a password for the"
send "\n"
expect "What filename should be used for the output zip file?"
send "\n"
expect eof
SCRIPT

echo -n "script created" >> /home/heeheetraubuntu/debug.txt #| gcloud secrets versions add kibana-certificate-pem --data-file=-

chmod +x /usr/share/elasticsearch/bin/https.sh
(cd /usr/share/elasticsearch/bin && ./https.sh)
echo -n "zip with cert created" >> /home/heeheetraubuntu/debug.txt #| gcloud secrets versions add kibana-certificate-pem --data-file=-
(cd /usr/share/elasticsearch && unzip "elasticsearch-ssl-http.zip")
gcloud secrets versions add kibana-certificate-pem --data-file="/usr/share/elasticsearch/kibana/elasticsearch-ca.pem"

echo -n "elastic started" >> /home/heeheetraubuntu/debug.txt

systemctl enable elasticsearch 
systemctl start elasticsearch
sleep 90




(cd /usr/share/elasticsearch/bin &&   yes | ./elasticsearch-setup-passwords auto > passwords.txt)
grep "^PASSWORD kibana =" /usr/share/elasticsearch/bin/passwords.txt |cut -c 19- |gcloud secrets versions add kibana-password --data-file=-
grep "^PASSWORD elastic =" /usr/share/elasticsearch/bin/passwords.txt |cut -c 20- |gcloud secrets versions add elastic-password --data-file=-
grep "^PASSWORD logstash_system =" /usr/share/elasticsearch/bin/passwords.txt |cut -c 28- |gcloud secrets versions add logstash-password --data-file=-
rm /usr/share/elasticsearch/bin/passwords.txt

mkdir /usr/share/elasticsearch/Logstash
cat << JSON > /usr/share/elasticsearch/Logstash/logstash-writer.json
{
  "cluster": ["manage_index_templates", "monitor"],    
  "indices": [
    {
      "names": [ "*" ],
      "privileges": ["write","create","create_index"]
    }
  ]
}
JSON
logstashpass=$(gcloud secrets versions access latest --secret="logstash-password")
cat << JSON > /usr/share/elasticsearch/Logstash/logstash-internal.json
{
  "password" : "$logstashpass",
  "roles" : [ "logstash_writer", "logstash_reader", "logstash_admin" ],
  "full_name" : "Internal Logstash User"
}
JSON
cat << JSON > /usr/share/elasticsearch/Logstash/logstash-reader.json
{
  "cluster": ["manage_logstash_pipelines"]
}
JSON

cat << SCRIPT >  /usr/share/elasticsearch/Logstash/sendJSON.sh
#!/bin/bash
shopt -s expand_aliases
alias logstashwriterrole='cat logstash-writer.json | curl -XPOST "https://localhost:9200/_security/role/logstash_writer?pretty" -H "Content-Type: application/json" -d @- --key /usr/share/elasticsearch/ca.crt -k -u elastic'
logstashwriterrole
alias logstashreaderrole='cat logstash-reader.json | curl -XPOST "https://localhost:9200/_security/role/logstash_reader?pretty" -H "Content-Type: application/json" -d @- --key /usr/share/elasticsearch/ca.crt -k -u elastic'
logstashreaderrole
alias logstashinternal='cat logstash-internal.json | curl -XPOST "https://localhost:9200/_security/user/logstash_internal?pretty" -H "Content-Type: application/json" -d @- --key /usr/share/elasticsearch/ca.crt -k -u elastic'
logstashinternal
# alias logstashuser='cat logstash-user.json | curl -XPOST "https://localhost:9200/_security/user/logstash_user?pretty" -H "Content-Type: application/json" -d @- --key /usr/share/elasticsearch/ca.crt -k -u elastic'
# logstashuser
curl -X PUT "https://localhost:9200/_security/user/logstash_system/_enable?pretty" --key /usr/share/elasticsearch/ca.crt -k -u elastic
SCRIPT
elasticpass=$(gcloud secrets versions access latest --secret="elastic-password")
cat << SCRIPT > /usr/share/elasticsearch/Logstash/logstash-pass.sh
#!/usr/bin/expect -f
set timeout -1
spawn ./sendJSON.sh
expect "Enter host password for user"
send "$elasticpass\n"
expect "Enter host password for user"
send "$elasticpass\n"
expect "Enter host password for user"
send "$elasticpass\n"
expect "Enter host password for user"
send "$elasticpass\n"
expect eof
SCRIPT
chmod +x /usr/share/elasticsearch/Logstash/sendJSON.sh
chmod +x /usr/share/elasticsearch/Logstash/logstash-pass.sh
(cd /usr/share/elasticsearch/Logstash && ./logstash-pass.sh)

#-----------------------------------------------------------OAUTH---------------
kibanapass=$(gcloud secrets versions access latest --secret="kibana-password")
cat << EOF > /etc/kibana/kibana.yml
server.port: 5601
server.host: "0.0.0.0"
elasticsearch.hosts: ["https://$(hostname -I| cut -d ' ' -f 1):9200"]
elasticsearch.username: "kibana_system"
elasticsearch.password: "$kibanapass"
elasticsearch.ssl.certificateAuthorities: [ "/usr/share/elasticsearch/kibana/elasticsearch-ca.pem" ]
EOF

systemctl start kibana
systemctl enable kibana 
sleep 90
cat << EOF > /opt/oauth2-proxy-v7.2.0.linux-amd64/start.sh
#!/bin/sh
/opt/oauth2-proxy-v7.2.0.linux-amd64/oauth2-proxy \
--email-domain=*  \
--http-address="http://0.0.0.0:4775"  \
--upstream="https://kibana.heehetra.pp.ua" \
--redirect-url="https://kibana.heeheetra.pp.ua/oauth2/callback" \
--cookie-secret="$(openssl rand -base64 16)" \
--cookie-secure=false \
--provider=github \
--client-id="$(gcloud secrets versions access latest --secret='oauth-github-client-id')" \
--client-secret="$(gcloud secrets versions access latest --secret='oauth-github-client-secret')"
EOF
chmod +x /opt/oauth2-proxy-v7.2.0.linux-amd64/start.sh


cat << EOF >  /etc/systemd/system/oauth2.service
[Unit]
Description=oauth2 service
After=network.target
StartLimitIntervalSec=0
[Service]
WorkingDirectory=/opt/oauth2-proxy-v7.2.0.linux-amd64/
ExecStart=/opt/oauth2-proxy-v7.2.0.linux-amd64/start.sh
[Install]
WantedBy=multi-user.target
EOF

mkdir /etc/nginx/ssl
(cd /etc/nginx/ssl && sudo openssl req -newkey rsa:4096  -x509  -sha256 -days 3650  -nodes  -out /etc/nginx/ssl/certificate.crt -keyout /etc/nginx/ssl/private.key -subj "/C=UA/ST=IvanoFrankivsk/L=IF/O=Security/OU=IT/CN=kibana.heeheetra.pp.ua")
sed -i '62s/^/#&/'  /etc/nginx/nginx.conf
chmod 655 /etc/nginx/ssl -R

cat << EOF > /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
        worker_connections 768;
}
http {
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
        gzip on;
        include /etc/nginx/conf.d/*.conf;
}
EOF

cat << "EOF" >> /etc/nginx/conf.d/kibana.conf
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name kibana.heeheetra.pp.ua:4775;
        rewrite ^ https://$server_name$request_uri? permanent;
}
server {
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
        server_name kibana.heeheetra.pp.ua;
        ssl_certificate     /etc/nginx/ssl/certificate.crt;
        ssl_certificate_key /etc/nginx/ssl/private.key;
        ssl_prefer_server_ciphers on;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers kEECDH+AES128:kEECDH:kEDH:-3DES:kRSA+AES128:kEDH+3DES:DES-CBC3-SHA:!RC4:!aNULL:!eNULL:!MD5:!EXPORT:!LOW:!SEED:!CAMELLIA:!IDEA:!PSK:!SRP:!SSLv2;
        ssl_session_cache    shared:SSL:64m;
        ssl_session_timeout  24h;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains;";
        add_header Content-Security-Policy-Report-Only "default-src https:; script-src https: 'unsafe-eval' 'unsafe-inline'; style-src https: 'unsafe-inline'; img-src https: data:; font-src https: data:; report-uri /csp-report";

        location /oauth2/ {
                proxy_pass       http://127.0.0.1:4775;
                proxy_set_header Host                    $host;
                proxy_set_header X-Real-IP               $remote_addr;
                proxy_set_header X-Scheme                $scheme;
                proxy_set_header X-Auth-Request-Redirect $request_uri;
        }
        location = /oauth2/auth {
                proxy_pass       http://127.0.0.1:4775;

                proxy_set_header Host             $host;
                proxy_set_header X-Real-IP        $remote_addr;
                proxy_set_header X-Scheme         $scheme;
                proxy_set_header Content-Length   "";
                proxy_pass_request_body           off;
        }
        location / {
                auth_request /oauth2/auth;
                error_page 401 = /oauth2/sign_in;
                auth_request_set $user   $upstream_http_x_auth_request_user;
                auth_request_set $email  $upstream_http_x_auth_request_email;
                proxy_set_header X-User  $user;
                proxy_set_header X-Email $email;
                auth_request_set $auth_cookie $upstream_http_set_cookie;
                add_header Set-Cookie $auth_cookie;
                proxy_pass http://127.0.0.1:5601;
        }
}
EOF



sudo systemctl start oauth2.service
sleep 60
sudo systemctl start nginx.service

echo "done"

