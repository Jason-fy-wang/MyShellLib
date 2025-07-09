sudo mkdir -p /var/lib/cloud/seed/nocloud
sudo cp /tmp/cloud-init.yaml /var/lib/cloud/seed/nocloud/user-data
sudo touch /var/lib/cloud/seed/nocloud/meta-data

sudo cloud-init clean --logs
sudo cloud-init init
sudo cloud-init modules --mode=config
sudo cloud-init modules --mode=final

sudo tail -n 50 /var/log/cloud-init-output.log

sudo cloud-init query userdata
