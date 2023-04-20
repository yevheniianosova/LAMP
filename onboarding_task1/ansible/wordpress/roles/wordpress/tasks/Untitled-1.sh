eheetraubuntu@logstash:~$ history
    1  sudo apt install openjdk-11-jre-headless
    2  curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
    3  echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
    4  sudo apt update
    5  sudo apt upgrade
    6  sudo apt install openjdk-11-jre-headless
    7  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    8  sudo apt-get install apt-transport-https
    9  echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
   10  sudo apt-get update && sudo apt-get install logstash
   11  cd logstash-8.5.3
   12  bin/logstash -e 'input { stdin { } } output { stdout {} }'
   13  sudo nsno /etc/logstash/conf.d/logstash.conf
   14  sudo nano /etc/logstash/conf.d/logstash.conf
   15  cd /etc/logstash/
   16  ls
   17  nano logstash-sample.conf
   18  sudo nano conf.d/logstash.conf
   19  nano pipelines.yml
   20  sudo nano pipelines.yml
   21  sudo systemctl start logstash.service
   22  sudo systemctl status logstash.service
   23  curl -XGET  "http://10.0.2.204:9200"
   24  curl -XGET  "http://10.0.2.254:9200"
   25  curl -XGET  "http://10.0.2.205:9200"
   26  sudo nano  /etc/elasticsearch/elasticsearch.yml
   27  curl -XGET  "http://10.0.2.205:9200"
   28  gsutil cp gs://wordpressbucket2022task/elasticsearch-ca.pem .
   29  gcloud auth
   30  gcloud auth login
   31  gsutil cp gs://wordpressbucket2022task/elasticsearch-ca.pem .
   32  sudo gsutil cp gs://wordpressbucket2022task/elasticsearch-ca.pem .
   33  ls
   34  curl -XGET  "https://10.0.2.205:9200/_cluster/health?wait_for_status=yellow&timeout=50s&pretty" --key elasticsearch-ca.pem  -k -u elastic
   35  sudo nano conf.d/logstash.conf
   36  sudo systemctl restart logstash
   37  sudo systemctl status logstash.service
   38  sudo nano conf.d/logstash.conf
   39  curl -XGET  "https://10.0.2.205:9200/_cluster/health?wait_for_status=yellow&timeout=50s&pretty" --key elasticsearch-ca.pem  -k -u elastic
   40  curl -XGET  "https://10.0.2.205:9200/_cat/indices" --key elasticsearch-ca.pem  -k -u elastic
   41  curl -XGET  "https://10.0.2.204:9200/_cat/indices" --key elasticsearch-ca.pem  -k -u elastic
   42  curl -XGET  "https://10.0.1.10:9200/_cat/indices" --key elasticsearch-ca.pem  -k -u elastic
   43  sudo systemctl enable logstash
   44  sudo systemctl status logstash
   45  sudo nano conf.d/logstash.conf
   46  sudo systemctl enable logstash
   47  curl -XGET  "https://10.0.1.10:9200/_cat/indices" --key elasticsearch-ca.pem  -k -u elastic
   48  ls
   49  sudo nano logstash.yml
   50  ls ~
   51  ls /home/
   52  ls /home/heeheetraubuntu/
   53  ls /home/ynoso/
   54  cd
   55  ls
   56  cd /etc/logstash/
   57  pwd
   58  sudo nano logstash.yml
   59  sudo systemctl enable logstash
   60  curl -XGET  "https://10.0.1.10:9200/_cat/indices" --key elasticsearch-ca.pem  -k -u elastic
   61  sudo nano logstash.yml
   62  sudo logstash setup --zOTf6D83cxhBBo4kxtjI
   63  sudo sudo logstash setup --zOTf6D83cxhBBo4kxtjI
   64  sudo  logstash --log.level=debug --config.debug|egrep 'logstash.runner'
   65  logstash --log.level=debug
   66  ls
   67  cd ..
   68  logstash --log.level=debug
   69  ls
   70  cd /etc/logstash/
   71  ls
   72  nano logstash.yml
   73  sudo nano logstash.yml
   74  cd conf.d/
   75  ls
   76  sudo nano logstash.conf
   77  sudo nano logstashlogs.conf
   78  sudo nano logstash.conf
   79  sudo nano logstashlogs.conf
   80  sudo systemctl restart logstash.service
   81  sudo nano logstash.conf
   82  sudo systemctl restart logstash.service
   83  sudo systemctl status logstash.service
   84  sudo nano logstash.conf
   85  ls
   86  ls !
   87  ls ~
   88  ls ../
   89  sudo nano logstash.conf
   90  sudo nano logstashlogs.conf
   91  sudo systemctl status logstash.service
   92  sudo systemctl restart logstash.service
   93  sudo systemctl status logstash.service
   94  sudo nano ../logstash.yml
   95  sudo systemctl restart logstash.service
   96  sudo systemctl status logstash.service
   97  sudo nano ../logstash.yml
   98  sudo nano logstashlogs.conf
   99  sudo nano ../logstash.yml
  100  sudo nano logstashlogs.conf
  101  sudo nano logstash.conf
  102  sudo nano logstashlogs.conf
  103  sudo systemctl restart logstash.service
  104  sudo systemctl status logstash.service
  105  sudo nano logstashlogs.conf
  106  sudo nano ../logstash.yml
  107  sudo nano logstashlogs.conf
  108  sudo systemctl restart logstash.service
  109  sudo systemctl status logstash.service
  110  sudo nano logstashlogs.conf
  111  ls /var/log/logstash/
  112  tail -f logstash-plain.log
  113  tail -f /var/log/logstash/logstash-plain.log
  114  ls /usr/share/logstash/conf.d/
  115  ls ../
  116  sudo nano ../pipelines.yml
  117  sudo systemctl restart logstash.service
  118  sudo systemctl status logstash.service
  119  tail -f /var/log/logstash/logstash-plain.log
  120  sudo systemctl restart logstash.service
  121  sudo systemctl status logstash.service
  122  tail -f /var/log/logstash/logstash-plain.log
  123  sudo nano ../pipelines.yml
  124  sudo nano ../logstash.yml
  125  sudo nano ../pipelines.yml
  126  sudo nano ../logstash.yml
  127  sudo systemctl restart logstash.service
  128  tail -f /var/log/logstash/logstash-plain.log
  129  sudo nano logstash.conf
  130  sudo nano logstashlogs.conf.conf
  131  sudo nano logstashlogs.conf
  132  sudo nano logstash.conf
  133  sudo mv logstash.conf logstash.bak
  134  ls
  135  sudo systemctl restart logstash.service
  136  tail -f /var/log/logstash/logstash-plain.log
  137  sudo systemctl status logstash.service
  138  tail -f /var/log/logstash/logstash-plain.log
  139  sudo nano logstashlogs.conf
  140  sudo systemctl restart logstash.service
  141  sudo systemctlstop logstash.service
  142  sudo systemctl stop logstash.service
  143  sudo service kill logstash
  144  sudo service logstash kill
  145  sudo service logstash.service kill
  146  sudo service logstash.service stop
  147  sudo service logstash stop
  148  sudo systemctl status logstash
  149  sudo nano logstash.conf
  150  cd /etc/logstash/
  151  sudo nano logstash.conf
  152  sudo nano conf.d/logstash.conf
  153  sudo nano conf.d/logstashlogs.conf
  154  sudo systemctl restart logstash.service
  155  sudo nano conf.d/logstashlogs.conf
  156  sudo systemctl restart logstash.service
  157  kill -sigterm pidof logstash
  158  pidof logstash
  159  kill -9 pidof logstash
  160  kill -9 (pidof logstash)
  161  kill -9 $(pidof logstash)
  162  ps -aux|grep logstash
  163  sudo systemctl status logstash
  164  sudo kill -9 532
  165  sudo systemctl status logstash
  166  sudo kill -9 1163
  167  sudo systemctl status logstash
  168  sudo kill -9 1219
  169  sudo systemctl stop logstash
  170  sudo systemctl status logstash
  171  sudo systemctl start logstash
  172  sudo systemctl status logstash
  173  cd conf.d/
  174  ls
  175  nano logstashlogs.conf
  176  nano logstash.bak
  177  sudo nano nano logstash.bak
  178  sudo nanoo logstash.bak
  179  sudo nano logstash.bak
  180  sudo mv logstash.bak filebeat.conf
  181  sudo mv logstashlogs.conf logstash.conf
  182  ls
  183  sudo systemctl stop logstash
  184  sudo systemctl start logstash
  185  sudo systemctl stop logstash
  186  sudo systemctl start logstash
  187  tail /var/log/logstash/logstash-plain.log
  188  sudo mv logstash.conf logstash.txt
  189  ls
  190  sudo systemctl stop logstash
  191  sudo systemctl status logstash
  192  sudo kill -9 1713
  193  sudo systemctl stop logstash
  194  sudo systemctl start logstash
  195  sudo systemctl status logstash
  196  tail /var/log/logstash/logstash-plain.log
  197  tail -f /var/log/logstash/logstash-plain.log
  198  cd /etc/logstash/conf.d/
  199  ls
  200  nano filebeat.conf
  201  sudo nano filebeat.conf
  202  cd ../
  203  ls
  204  rm pipelines.yml
  205  sudo rm pipelines.yml
  206  ls
  207  cd /etc/logstash/conf.d/
  208  sudo nano filebeat.conf
  209  sudo netstat -tulpn | grep LISTEN | grep 5044
  210  sudo apt install net-tools
  211  sudo netstat -tulpn | grep LISTEN | grep 5044
  212  sudo nano filebeat.conf
  213  sudo systemctl stop logstash.service
  214  sudo systemctl startp logstash.service
  215  sudo systemctl start logstash.service
  216  tail -f /var/log/logstash/logstash-plain
  217  tail -f /var/log/logstash/logstash-plain.log
  218  sudo nano filebeat.conf
  219  sudo systemctl stop logstash.service
  220  sudo systemctl start logstash.service
  221  tail -f /var/log/logstash/logstash-plain.log
  222  sudo nano filebeat.conf
  223  sudo systemctl stop logstash.service
  224  sudo systemctl start logstash.service
  225  tail -f /var/log/logstash/logstash-plain.log
  226  sudo netstat -tulpn | grep LISTEN | grep 5044
  227  ls ../
  228  sudo nano ../jvm.options
  229  sudo systemctl stop logstash.service
  230  sudo systemctl start logstash.service
  231  tail -f /var/log/logstash/logstash-plain.log
  232  sudo netstat -tulpn | grep LISTEN | grep 5044
  233  sudo gsutil cp -r /etc/logstash/  gs://
  234  gcloud auth login
  235  sudo gsutil cp -r /etc/logstash/  gs://wordpressbucket2022task
  236  gcloud auth
  237  gcloud auth login
  238  gcloud config set project gcp101845-educoeynoso]
  239  gcloud config set project gcp101845-educoeynoso
  240  sudo gsutil cp -r /etc/logstash/  gs://wordpressbucket2022task
  241  sudo gsutil cp -r /etc/logstash  gs://wordpressbucket2022task
  242  gsutil cp -r /etc/logstash/* gs://wordpressbucket2022task
  243  sudo gsutil cp -r /etc/logstash/* gs://wordpressbucket2022task
  244  gsutil config -b\
  245  gsutil config -b
  246  gsutil config -b\
  247  sudo gsutil cp -r /etc/logstash/* gs://wordpressbucket2022task
  248  cd /etc/logstash/
  249  ls
  250  sudo gsutil cp -r /etc/logstash/* gs://wordpressbucket2022task
  251  exot
  252  exit
  253  sudo gsutil cp -r /etc/logstash/* gs://wordpressbucket2022task
  254  sudo gsutil cp -r /etc/logstash/ gs://wordpressbucket2022task
  255  sudo ls /etc/logstash
  256  sudo ls -lah /etc/logstash
  257  sudo chmod -wx -r/etc/logstash
  258  sudo chmod -wx -r /etc/logstash
  259  sudo chmod -wx -r/etc/logstash
  260  sudo ls -lah /etc/logstash
  261  sudo chmod +wx -r/etc/logstash
  262  sudo chmod +wx -r /etc/logstash
  263  sudo chmod -r  /etc/logstash
  264  sudo chmod +wx -r /etc/logstash
  265  sudo ls -lah /etc/logstash
  266  sudo chmod r-- -r  /etc/logstash
  267  sudo ls -lah /etc/
  268  sudo ls -lah /etc/vim