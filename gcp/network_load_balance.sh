## 1. create multiple vm instances
gcloud compute instances create www1 --zone=ZONE --tags=network-lb-tag --machine-type=e2-small --image-family=debian-11 --image-project=debian-cloud --metadata=startup-scrupt='#!/bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
echo "
    <h3>Web Server: www1</h3>" | tee /var/www/html/index.html
'

gcloud compute instances create www2 --zone=ZONE --tags=network-lb-tag --machine-type=e2-small --image-family=debian-11 --image-project=debian-cloud --metadata=startup-scrupt='#!/bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
echo "
    <h3>Web Server: www2</h3>" | tee /var/www/html/index.html
'

gcloud compute instances create www3 --zone=ZONE --tags=network-lb-tag --machine-type=e2-small --image-family=debian-11 --image-project=debian-cloud --metadata=startup-scrupt='#!/bin/bash
apt-get update
apt-get install apache2 -y
service apache2 restart
echo "
    <h3>Web Server: www3</h3>" | tee /var/www/html/index.html
'


## 2. create firewall rule to allow external traffic
gcloud compute firewall-rules create www-firewall-network-lb --target-tags netowork-lb-tag --allow tcp:80

## 3. create external ip  for load balancer
gcloud compute addresses create network-lb-ip-1 --region Region

## 4. add legacy HTTP health check
gcloud compute http-health-checks create basic-check

## 5. create target-pool
gcloud computee target-pools create www-pool --region Region --http-health-check basic-check

## 6. add vm instance to target-pool
gcloud compute target-pools add-instances www-pool --instances www1,www2,www3

## 7. add forwarding rule
gcloud compute forwarding-rules create www-rule --region Region --ports 80 --address network-lb-ip-1 --target-pool www-pool


## 8. test
### 8.1  get www-rule infos
gcloud compute forwarding-rules describe www-rule --region Region

### 8.2 get external ip
EXTERNAL_IP=$(gcloud compute forwarding-rules describe www-rule --region Region --format=json | jq -r .IPAddress)

while true; do curl -m1 http://${EXTERNAL_IP}; done

