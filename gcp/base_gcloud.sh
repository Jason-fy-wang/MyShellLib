# set config
gcloud config set compute/region us-west1
glcoud config set compute zone us-west1-a

gcloud config get-value compute/region
gcloud config get-value compute/zone

gcloud config get-value project

gcloud config list

# auth
gcloud auth list

# project detail
gcloud compute project-info describe --project $(gcloud config get-value project)


# vm instances
gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE

gcloud compute instances list --filter="name=('gcelab2')"

gcloud compute ssh gcelab2 --zone $ZONE 

gcloud compute instances add-tag gcelab2 --tags http-server,https-server

curl http://$(gcloud compute instances list --filter=name:gcelab2 --format='value(EXTERNAL_IP)')


# firewall-rules
gcloud compute firewall-rules list
gcloud compute firewall-rules list --filter="network='default'"
gcloud compute firewall-rules list --filter="NETWORK:'default' AND ALLOW:'icmp'"

gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source=ranges=0.0.0.0/0  --target-tags=http-server

gcloud compute firewall-rules list --filter=ALLOW:'80'

## system logs
gcloud logging logs list
gcloud logging logs list --filter="compute"
gcloud logging read "resource.type=gce_instance" --limit 5
gcloud logging read "resource.type=gce_instance AND labels.instance_name='gcelab2'"  --limit 5


#
gcloud components list
