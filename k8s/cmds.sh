# check yaml resources
kubectl explain deployment
### check the specific field of deployment
kubectl explanin deployment.spec


# token
kubeadm token list
kubeadm token create
# 证书指纹
openssl x509  -pubkey -in /etc/kubernetes/pki/ca.crt  | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
kubeadm token create --print-join-command

# label
kubectl lable pod nginx app=linux

kubectl get pod -l type=app
kubectl get pod -l 'test in (1.0.0  1.1.0  1.1.1)'
kubectl get pod -l type!=app,'test in (1.0.0  1.1.0  1.1.1)'

# edit
kubectl edit pod nginx   # dynamic edit existing config
## update config item by cmd
kubectl set image  deployment/nginx-deploy nginx=nginx:1.7.9

#
kubectl get deploy nginx-deploy -o yaml

# get info
kubectl get pod
kubectl get deploy -n namespace (-A all namespace)
### get yaml describe file from exising pod
kubectl get pod nginx -o yaml > nginx_pod.yaml
kubectl get pod nginx -o yaml | less
kubectl get replicaset
kubectl get service
## show multiple item at once
kubectl get pod,deploy,svc  --show-labels
## volume info
kubectl get pvc
## daemset
kubectl get daemonset
## NODE
kubectl get node
kubectl get hpa
kubectl get endpoints
## service account
kubectl get serviceaccount (sa)
kubectl get serviceaccount -n kube-system
kubectl get role roleName [-n namespace]
### get yaml describe file from exising role
kubectl get role rolename -o yaml
kubectl get clusterrole  roleName -o yaml
kubectl get rolebinding --all-namespaces
kubectl get clusterrolebind --all-namespaces

# create deploy by cmd
kubectl create deploy nginx-deploy --image:1.14.7


# rollback
## check history release
kubectl rollout history deployment/nginx-deploy
## check specific version
kubectl rollout history deployment/nginx-deploy  --revision=2
## rollback
kubectl rollout undo deployment/nginx-deploy   # without version specifc, will rollback to last version
## rollback with specific version
kubectl rollout undo deployment/nginx-deploy --to-revision=2
## rollout status
kubectl rollout status deployment/nginx-deploy
## temporary pause the rollout
kubectl rollout pause deploy nginx-deploy
## resume rollout
kubectl rollout resume deploy nginx-deploy


# describe
## pod
kubectl describe pod  pod-name
## deploy
kubectl describe deployment nginx-deploy
## volume
kubectl describe pvc pvc_name
## daemonset
kubectl describe daemonset  set_name


# scale
## statefulset
kubectl scale statefulset web --replicas=5
kubectl patch statefulset web -p '{"spec": {"replicas": 5}'
## update image
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value": "nginx:1.9.1"}]'




# label
kubectl label node node_name type=microservice


# HPA(horizontal pod autoscaler)
## when cpu occupy to 20%, then will auto scale up. 
kubectl autoscale deploy <deploy_name>  --cpu-percent=20  --min=2  --max=5




# top.  when you use top, you need install mertics service first
kubectl top pods
kubectl top hpa


# namespace
kubectl create ns ingress_namespace


# taint
## add taint
kubectl taint node NodeName  dedicated=groupname:NoSchedule (NoExecute)
## remove taint
kubectl taint node NodeName dedicated=groupname:NoSchedule-
## show taint
kubectl describe node NodeName


# toleration


# exec cmd in container
kubectl exec -it podName -- sh
## if the pod have multiple containers
kubectl exec -it podName -c containerName -- sh


# resource object
kubectl api-resources


# create service with cmd
kubectl expose deployment deployName --name=nginx-deploy  --port=8080 --target-port=pod_port

kubectl expose deployment deployName --name=nginx-svc --port=8080 --target-port=80 --type=NodePort

# update pod/deploy config
kubectl set image deploy nginx-deploy nginx=nginx:1.14.2


## 3service and pod's port
# - port: the port used by service's ClusterIp
# - nodePort: the port defined in the node . (range: 30000-32767)
# - targetPort: pod's port
# - continerPort: container's port

## run pod temporary
kubectl run curl --image=busybox -i --tty --rm
## 带curl的测试镜像
# image: alpine:3.12
#  apk add curl   ## install curl
kbectl run -it --rm alpine --image=alpine:latest






