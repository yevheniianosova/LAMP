IP=$(gcloud compute instances list --filter="name~'^elasticsearch'" --format="list (INTERNAL_IP)" | cut -c 4- | sed -E 's|^(.*)$|"https://\1:9200"|' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/,/g')
logstashpass=$(gcloud secrets versions access latest --secret="logstash-password")
cat << EOF > /etc/logstash/conf.d/filebeat.conf
# Beats -> Logstash -> Elasticsearch pipeline.
input {
  beats {
    host => "0.0.0.0"
    port => "5044"
  }
}

output {
  elasticsearch {
    hosts => [$IP]
    index => "apache-%{+YYYY.MM.dd}"
    ssl_certificate_verification => false
    user => logstash_internal
    password => $logstashpass
  }
}
EOF

sed -i '88s|^|path.config: "/etc/logstash/conf.d/*.conf"\n|'  /etc/logstash/logstash.yml
sed -i '38s|^|-Djava.net.preferIPv4Stack=true\n|'  /etc/logstash/jvm.options
# sed -i '62s/^/#&/'  
sudo rm pipelines.yml 
sudo systemctl start logstash.service
sudo systemctl enable logstash
  