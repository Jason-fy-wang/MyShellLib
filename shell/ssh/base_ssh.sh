# ssh 端口转发的使用
## 1. 转发到远端
    ssh -C -f -N -g -L 本地端口:目标IP:目标端口   用户名@目标IP
## 2. 转发到本地
    ssh -C -f -N -T -g -R <local-host>:<local-port>:<remote-host>:<remote-port>  user@host
    local-host  可省略
    如:
        ssh -NTf -R 8888:127.0.0.1:8080  root@host
    ssh -C -f -N -g -D listen_port user@目标host
参数: 
-C: 压缩数据传输
-f: 后台运行
-N: 表示值连接远程主机, 不打开远程shell
-T: 不为这个连接分配tty
-NT: 代表这个ssh连接只用来传输数据,不执行远程操作
-g: 在-L/-R/-D参数中,允许远程主机连接到建立的转发的端口, 如果不加这个参数,只允许本地主机连接
-R: 将远程主机某个端口转发到本地主机的指定端口, 反向代理
-L: 将端口绑定到本地客户端, 正向代理
-D: 动态转发

-L [local_bind_address]:localport:<remote_host>:remote_port
# ssh -L 5901:facebook.coremote_bind_addressm:5902 user@host  把本地5901端口绑定到了远程 facebook.com的5902端口

-R <remote-host>:<remote-port>:<local-host>:<local-port> user@host
注意: 远程转发是最常用的内网穿透. ssh远程转发默认只能绑定远程主机的本地地址,即127.0.0.1. 如果
想要监听来自其他addr的连接, 需要添加配置: 
    GatewayPorts yes
# ssh -R 0.0.0.0:8080:80 user@host
    # 访问0.0.0.0:8080地址,即是访问本地的80 web端口


-D: ssh -D <local-port>  <ssh-server>
    ssh -D  7001 SSH-Server



## 配置:
# 服务器端配置: /etc/ssh/sshd_config
# 内网穿透时, 可以监听其他addr的地址
GatewayPorts yes
# 每隔30s, 服务器像客户端发送心跳
ClientAliveInterval 30
# 3此心跳无响应后,会认为此Client已经断开
ClientAliveCountMax 3
# 每隔60s向服务器发送要给空包
ServerAliveInterval 60
# 如果超过两次响应,就断开
ServerAliveCountMax 2
#  转发失败后退出, 便于重连
ExitOnForwardFailure yes

#使用
ssh -o ServerAliveInteval=30 root@host