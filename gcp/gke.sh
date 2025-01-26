## create cluster
gcloud container clusters create --machine-type=e2-medium --zone=ZONE lab-cluster


## get cluster credentials
gcloud container clusters get-credentials lab-cluster

## delete cluster
gcloud container clusters delete lab-cluster

## deploy app to cluster
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0


kubectl expose deployment hello-server --type=LoadBalancer --port=8080


kubectl get service

kubectl logs -f monolith

kubectl exec monolith --stdin --tty -c monolith -- /bin/sh

kubectl create secret generic tls-certs --from-file tls/*

kubectl create configmap nginx-proxy-conf --from-file nginx/nginx.conf

kubectl create -f pods/secure-monolith.yaml

## tags
kubectl get pods -l "app=monolith"
kubectl get pods -l "app=monolith,secure=enabled"

kubectl label pods sec-monolith "secure=enabled"
kubectl get pods secure-monolith --show-labels
kubectl describe services monolith 


