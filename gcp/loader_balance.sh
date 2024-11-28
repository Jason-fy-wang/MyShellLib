# global https load balance
# 1. 创建健康检查
gcloud compute health-checks create http my-http-health-check \
    --port 80 --request-path "/"

# 2. 创建后端服务
gcloud compute backend-services create my-backend-service \
    --protocol HTTP \
    --health-checks my-http-health-check \
    --global

# 3. 将实例组添加到后端服务
gcloud compute backend-services add-backend my-backend-service \
    --instance-group my-instance-group \
    --instance-group-zone us-central1-a \
    --global

# 4. 创建 URL 映射
gcloud compute url-maps create my-url-map \
    --default-service my-backend-service

# 5. 创建目标 HTTP 代理
gcloud compute target-http-proxies create my-http-proxy \
    --url-map my-url-map

# 6. 创建前端 IP 地址和转发规则
gcloud compute forwarding-rules create my-http-forwarding-rule \
    --address 0.0.0.0 \
    --global \
    --target-http-proxy my-http-proxy \
    --ports 80


## global TCP/UDP load balance
# 1. 创建健康检查
gcloud compute health-checks create tcp my-tcp-health-check \
    --port 8080

# 2. 创建后端服务
gcloud compute backend-services create my-tcp-backend-service \
    --protocol TCP \
    --health-checks my-tcp-health-check \
    --global

# 3. 添加实例组到后端服务
gcloud compute backend-services add-backend my-tcp-backend-service \
    --instance-group my-instance-group \
    --instance-group-zone us-central1-a \
    --global

# 4. 创建目标 TCP 代理
gcloud compute target-tcp-proxies create my-tcp-proxy \
    --backend-service my-tcp-backend-service

# 5. 创建转发规则
gcloud compute forwarding-rules create my-tcp-forwarding-rule \
    --load-balancing-scheme EXTERNAL \
    --address 0.0.0.0 \
    --global \
    --target-tcp-proxy my-tcp-proxy \
    --ports 8080


## internal http(s) load balance
# 1. 创建健康检查
gcloud compute health-checks create http my-internal-http-health-check \
    --request-path "/" \
    --port 80

# 2. 创建后端服务
gcloud compute backend-services create my-internal-backend-service \
    --protocol HTTP \
    --health-checks my-internal-http-health-check \
    --region us-central1 \
    --load-balancing-scheme INTERNAL

# 3. 将实例组添加到后端服务
gcloud compute backend-services add-backend my-internal-backend-service \
    --instance-group my-instance-group \
    --instance-group-zone us-central1-a \
    --region us-central1

# 4. 创建内部转发规则
gcloud compute forwarding-rules create my-internal-http-forwarding-rule \
    --load-balancing-scheme INTERNAL \
    --address 10.0.0.10 \
    --ports 80 \
    --region us-central1 \
    --backend-service my-internal-backend-service \
    --ip-protocol TCP


## internal tcp/udp load balance
# 1. 创建健康检查
gcloud compute health-checks create tcp my-internal-tcp-health-check \
    --port 8080

# 2. 创建后端服务
gcloud compute backend-services create my-internal-tcp-backend-service \
    --protocol TCP \
    --health-checks my-internal-tcp-health-check \
    --region us-central1 \
    --load-balancing-scheme INTERNAL

# 3. 将实例组添加到后端服务
gcloud compute backend-services add-backend my-internal-tcp-backend-service \
    --instance-group my-instance-group \
    --instance-group-zone us-central1-a \
    --region us-central1

# 4. 创建内部转发规则
gcloud compute forwarding-rules create my-internal-tcp-forwarding-rule \
    --load-balancing-scheme INTERNAL \
    --address 10.0.0.20 \
    --ports 8080 \
    --region us-central1 \
    --backend-service my-internal-tcp-backend-service \
    --ip-protocol TCP
