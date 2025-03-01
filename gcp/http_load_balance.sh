# 1. create vm-instance-template
gcloud compute instance-templates create lb-backend-template \ 
                                            --region=Region  \
                                            --network=default \
                                            --subnet=deault     \
                                            --tags=allow-health-check \
                                            --machine-type=e2-medium \
                                            --image-family=debian-11    \
                                            --image-project=debian-cloud \
                                            --metadata=startup-script='#!/bin/bash
                                                apt-get update
                                                apt-get install -y apache2
                                                a2ensite default-ssl
                                                a2enmod ssl
                                                vm-hostname="$(curl -H 'Metadata-Flavor:Google' http://169.254.169.254/computeMetadata/v1/instance/name)"
                                                echo "page server from: ${vm-hostname}" | tee /var/www/html/index.html
                                                systemctl restart apache2
                                            '

gcloud compute instance-templates create lb-backend-template \ 
                                            --region=Region  \
                                            --network=default \
                                            --subnet=deault     \
                                            --tags=allow-health-check \
                                            --machine-type=e2-medium \
                                            --image-family=debian-11    \
                                            --image-project=debian-cloud \  
            --metadata-from-file startup-script=/path/to/new-startup-script.sh

# 2. create instance-group  base on template
gcloud compute instance-groups managed create lb-backend-group --template=lb-backend-template --size=2 --zone=Zone

gcloud compute instance-groups set-named-ports lb-backend-group \
    --named-ports http:80 \
    --zone ZONE


# 3. create firewall rule
## The ingress rule allows traffic from the Google Cloud health checking systems (130.211.0.0/22 and 35.191.0.0/16)
gcloud compute firewall-rules create fw-allow-health-check \
                                        --network=default  \
                                         --action=allow    \
                                         --direction=ingress \
                                         --source-ranges=130.211.0.0/22,35.191.0.0/16 \
                                          --target-tags=allow-health-check \
                                           --rules=tcp:80


# 4. set up a global static external ip address for load-balancer
gcloud compute addresses create lb-ipv4-1 \
                        --ip-version=IPV4 \
                        --global


## 4.1  check global ip
gcloud compute addresses describe lb-ipv4-1 --format="get(address)" --global


# 5. create a health check for load balancer
gcloud compute health-checks create http http-basic-check --port 80


# 6. ceate backed service
gcloud compute backend-services create web-backend-service \
                                --protocol=HTTP \
                                --port-name=http \
                                --health-checks=http-basic-check \
                                --global

# 7. add instance-group to the backend service
gcloud compute backend-services add-backend web-backend-service --instance-group=lb-backend-group --instance-group-zone=Zone --global


# 8. create URL map
gcloud compute url-maps create web-map-http --default-service web-backend-service


# 9. create target http-proxy to route requests to url-map
gcloud compute target-http-proxies create http-lb-proxy --url-map web-map-http


# 10. create blobal forwarding-rule to route incoming requests to proxy
gcloud compute forwarding-rules create http-content-rule --address=lb-ipv4-1  --global --target-http-proxy=http-lb-proxy --ports=80




## delete operation
gcloud compute forwarding-rules delete http-content-rule --global
gcloud compute target-http-proxies delete http-lb-proxy

gcloud compute url-maps delete web-map-http
gcloud compute backend-services delete web-backend-service --global
gcloud compute instance-groups managed delete lb-backend-group --zone=us-central1-a

gcloud compute instance-templates delete lb-backend-template

gcloud compute instances add-tags backend-group-dc1s --tags allow-health-check --zone=us-west3-b

## create new template and rolling update instance with new template
gcloud compute instance-groups managed set-instance-template my-instance-group \
    --template new-template \
    --zone us-central1-a

gcloud compute instance-groups managed rolling-action replace INSTANCE_GROUP_NAME \
     --max-surge 1 \
    --max-unavailable 0 \
    --zone ZONE

gcloud compute instances add-metadata my-instance \
    --metadata startup-script='#!/bin/bash
echo "Hello, World!" > /var/tmp/startup.log' \
    --zone us-central1-a