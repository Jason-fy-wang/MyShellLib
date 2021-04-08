# LVS base info
:'
LVS 是Linux Virtual Server的简称, 也就是linux虚拟服务器. 官网是www.linuxvirtualserver.
在linux2.4之后内置了LVS的功能模块,即无需任何补丁,可直接使用LVS的功能.
优点:
1. 工作在网络层, 可以实现高性能,高可用的服务器集群技术
2. 廉价, 可把许多低性能的服务器组合在一起形成一个超级服务器
3. 易用, 配置简单, 且有多种负载均衡的方法
4. 稳定可靠, 即使在集群的服务器中某台服务器无法正常工作, 也不影响整体效果
5. 可扩展性非常好
'

:'
安装:
yum install -y ipvsadm

virtual-service-address: 指虚拟服务器的IP地址
real-service-address: 是指真实服务器的IP地址
scheduler: 调度算法

ipvsadm用法:
# 添加一条虚拟服务器信息到表中
ipvsadm -A|E -t|u|f  virtual-service-address:port   [-s sceduler]  [-p[timeout]] [-M netmask]
# 删除虚拟服务器
ipvsadm -D  -t|u|f  virtual-service-address
# 清空虚拟服务器表
ipvadm -C
# 从文件file中恢复虚拟服务器信息
ipvdadm -R  file
# 保存虚拟服务器信息到文件file中
ipvsadm -S  file
# 添加一个真实服务器信息到 虚拟服务器中红
ipvsadm  -a|e  -t|u|f  virtual-service-address:port -r real-server-addr:port [-g|i|m]  [-w weight]
# 删除虚拟服务器中的一条 真实服务器信息
ipvsadm  -d  -t|u|f  virtual-service-addr:port  -r real-server-addr:port
# 查看虚拟服务器信息
# 
ipsvadm -Z [-t|u|f virtual-service-addr:port]
# 设置超时
ipvsadm --set tcp tcpfin udp
#
ipvsadm  --start-daemon state [--mcast-interface interface]
ipvsadm  --stop-daemon

参数解析,两种命令选项格式, 长的和短的,具有相同的意思
-A  --add-service  # 在内核的虚拟服务器表中添加一条新的虚拟虚拟服务器记录. 也即是增加一台新的虚拟服务器
-E  --edit-service  # 编辑内核虚拟服务器表中的一条虚拟服务器记录
-D  --delete-service  # 删除内核服务器表中的一条虚拟服务器记录
-C  --clear         # 清除内核虚拟服务器表中的所有记录
-R  --restore       # 恢复虚拟服务器规则
-S  --save          # 保存虚拟服务器规则, 输出为-R 选项可读的格式

-a  --add-server    # 在内核虚拟器表的一条记录中添加一条新的真实服务器记录. 也就是在一个虚拟服务器中增加一条真实服务器
-e  --edit-server   # 编辑一条虚拟服务器记录中的某条真实服务器记录
-d  --delete-server # 删除一条虚拟服务器记录中的某条真实服务器记录

-L|-l  --list       # 显示内核虚拟服务器列表
-Z    --zero        # 虚拟服务器表技术清零 (清空当前的链接数量等)

--set tcp tcpfin udp # 设置连接超时
--start-daemon      # 启动同步守护进程. 后可以是master或backup,用来说明LVS Router是master或backup,在这个功能上可以采用keepalived的vrrp功能
--stop-daemon       # 停止同步守护进程
-h --help           # 帮助信息

# 其他选项
-t  --tcp-service service-address # 说明虚拟服务器提供的是TCP的服务 [vip:port] or [real-server-ip:port]
-u  --udp-service service-address # 说明虚拟服务器提供的是UDP的服务 [vip:port] or [real-server-ip:port]
-f  --fwmark-service fwmark # 说明是经过iptables标记过的服务类型
-s  --scheduler  scheduler  # 使用的调度算法,有这样几个选项:rr|wrr|lc|wlc|lblc|lblcr|dh|sh|sed|nq,默认为wlc
-p  --persistent        # 持久稳固的服务. 这个选项的意思是来自同一个客户的多次请求,将被同一个真实服务器处理, timeout默认值为300s
-M  --netmask           # 子网掩码
-r  --real-server  server-address   # 真实服务器 [real-server-ip:port]
-g  --gatewaying    # 指定LVS的工作模式为直接路由模式(也是LVS默认的模式)
-i  --ipip      # 指定LVS的工作模式为隧道模式
-m  --masquerading  # 之地给你LVS的工作模式为 NAT 模式
-w  --weight  num  # 真实服务器的权值
--mcast-interface  interface # 指定组播的同步接口
-c  --connection    # 显示LVS目前的连接,如 ipvsadm -L -c
--timeout   # 显示tcp tcpfin udp的timeout值, 如: ipvdadm -L --timeout
--daemon    # 显示同步守护进程状态
--stats # 显示统计信息
--rate  # 显示速率信息
--sort  # 对虚拟服务器和真实服务器排序输出
--numeric -n # 输出IP地址和端口的数字形式
'

:'
调度算法:
1. fixed  scheduling  method 静态调度方法
rr  # 轮询
将外部请求轮流分配到真实服务器上, 它均等的对待每一台服务器, 而不管服务器上的实际连接数和系统负载

wrr # 加权轮询
根据真实服务器的不同处理能力来调度访问请求.这样可以保证处理能力强的服务器处理更多的访问流量,调度器可以
自动问询真实服务器的负载,并动态调整权值

dh  # 目标地址hash
算法是针对目标ip地址的负载均衡,是一种静态映射算法. 通过一个散列(hash)函数将一个目标ip地址映射到一台服务器.
先根据请求的目标ip地址,作为散列键从静态分配的散列表中找出对应的服务器,若服务器是可用的且未超载,将请求发送到该服务i去,
否则返回空

sh  # 源地址hash
与dh相似,根据请求的源ip地址作为hash键,从静态分配的散列表中找出对应的服务器.

2. Dynamic scheduling method 动态调度方法
lc # 最少连接
最少连接调度算法动态的将网络请求调度到已建立的链接数最少的服务器上. 如果集群的服务器系统性能相近,采用最少连接可以较好
的均衡负载

wlc # 加权最少连接
在集群中服务器性能差异较大的情况下,调度器采用加权最少连接调度算法优化负载均衡性能,具有较高权值的服务器将承受比较大比例的活动连接负载.
调度器可以自动询问真实服务器的负载情况,并动态的调整其权值

sed # 最少期望延迟
基于wlc算法,举例说明:ABC 三台服务器权重123,连接数也是123, name如果使用wlc算法的话,一个新请求进入时它可能会分配给ABC中任意一个,使用SED算法后会进行
这样这样一个计算:
A: (1+1)/2
B: (1+2)/2
C: (1+3)/3
根据运算结果, 连接给C

nq # 从不排队调度算法
无需排队, 如果有台realserver的连接数为0, 就直接分配过去, 不需要进行sed运算

lblc # 基于本地的最少连接
此算法主要是针对目标IP地址的负载均衡, 目前主要用于cache集群系统.
该算法根据请求的目标IP地址找出该目标IP地址最近使用的服务器,若该服务是可用的且没有超载, 则将请求发送到该服务器
若服务器不存在,或者该服务器超载且有服务器处于一半的工作负载,则使用`最少连接`原则选出一个可用的服务器,经请求发送到该服务器

lblcr # 带复制的基于本地的最少连接
该算法针对目标IP地址的负载均衡, 目前主要用于cache集群系统
它与lblc不同之处是: 它要维护一个从目标ip地址到一组服务器的映射, 而lblc算法维护一个从目标ip地址到一台服务器的映射
该算法根据请求的目标ip地址找出该目标ip地址对应的服务器组,按`最少连接`原则从服务器组中选出一台服务器
若服务器没有超载,将请求发送到该服务器; 若服务器超载,则按`最少连接`原则从这个集群中选出一台服务器,将该服务器加入到服务器组中,将
请求发送到该服务器. 同时,当该服务器组有一段时间没有被修改, 将最忙的服务器从服务器组中删除,以降低复制的程度.
'


:'
NAT 模式的一个部署
ipvsadm  -A -t 192.168.0.200:80  -s rr   # 添加一个虚拟服务器,并指定调度算法为  rr
ipvsadm  -a -t 192.168.0.200:80 -r 172.16.100.10 -m # 添加真实服务器到虚拟服务器中,并指定工作模式为NAT
ipvsadm  -a -t 192.168.0.200:80 -r 172.16.100.11 -m 
# 查看ipvs规则表
ipvsadm  -L -n
IP Virtual Server version 1.2.1 (size=4096) 
Prot LocalAddress:Port Scheduler Flags
-> RemoteAddress:Port Forward Weight ActiveConn InActConn
TCP 192.168.0.200:80 rr
-> 172.16.100.10:80 Masq 1 0 0 
-> 172.16.100.11:80 Masq 1 0 0 
'



:'
arp_ignore


'