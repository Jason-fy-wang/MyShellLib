:'
arp_ignore 定义了对目标为本机IP的arp询问的不同应答模式
arp_announce 对网络接口(网卡)上发出的arp请求包中的源地址做出相应的限制; 主机会根据这个参数值的不同
    选择使用IP数据包的源ip或当前网络接口卡的ip地址作为arp请求包的源ip地址

arp_ignore
define different modes  for  sending replies  in response to received ARP requests
that  resolve local target IP address:
0:(default) reply  for any  local target IP address, configured on any interface
    响应任意网卡上接收到的对本地IP地址的arp请求(包括回环网卡上的地址),而不管该目的IP是否在接收网卡上

1: reply only if the target IP address is local address configured on the incoming interface
    只响应目的IP地址接收网卡上的本地地址的ARP请求
2: reply only if the target IP address is local address configured on the incoming
    interface and both with the sender`s ip address are part from same subnet  on this interface
    只响应每一滴IP地址为接收网卡上的本地地址arp请求,并且ARP请求的源IP必须和接收网卡同段
3: do not reply for local address configured with scope host, only resolutions for global and 
    link addresses are replied
    如果ARP 请求数据包所请求的IP地址对应的本地地址其作用域(scope)为主机(host),则不回应arp响应数据包,如果作用域为全局
    (global)或链路(link),则回应ARP响应数据包
4-7: reserved
8: do  not reply  for all local address
    不回应所有的ARP请求


arp_announce
arp_announce的作用是控制系统在对外发送arp请求时,如何选择arp请求数据包的源IP地址.(比如: 系统准备通过网卡发送一个数据包a,这时数据包a
的源IP和目的IP一般都是知道的,而根据目的IP查询路由表,发送网卡也是确定的, 故源MAC地址也是知道的, 这时就差确定目的MAC地址了.而想要
获取目的IP对应的MAC地址, 就需要发送ARP请求. ARP请求的目的IP自然就是想要获取其MAC地址的IP, 而ARP请求的源IP时什么呢? 可能第一反应会
以为肯定时数据包a的源IP地址,但是这个也不是一定的, ARP请求的源IP是可以选择的,控制这个地址如何选择就是arp_announce的作用)
define different restriction levels for announcing the local source IP address from IP
packets in ARP requests send on  interface:

0:(default)Use any local address, configured on any interface
    允许使用任意网卡上的ip地址作为arp请求的源IP,通常就是使用数据包a的源IP
1: Try to avoid  local address that  are not in the target`s subnet for this interface.
    This mode is useful when  target hosts  reachable via this  interface require the source 
    IP address in ARP  requests to be part of  their logical network configured on the 
    receiving interface. When we  generate the request we will check all our subnets that 
    include the target IP and will preserve the source adress if it is from such subnet. If 
    there is no such subnet we select source address according to the rules for level 2.
    应尽量避免使用不属于该发送网卡子网的本地地址作为发送arp请求的源IP地址

2: Always use the best local address for this target. In this mode we ignore the source address
    in the IP packet and try to select local address that we prefer for talks with the target
    host. Such local address is selected by looking for primary IP addresses on all our subnets 
    on the outgoing interface that include the target IP address. If no suitable local address 
    is found we select the first local address we have on the outgoing interface or on all other 
    interfaces, with the hope we will receive reply for our request and even sometimes no matter
    the source IP address we announce. 
    忽略IP数据包的源IP地址,选择该发送网卡上最适合的本地地址作为arp请求的源IP地址.
'


:'
arp在DR模式下的配置

1. arp_ignore
因为DR模式下,每个真实服务器节点都要在回环网卡上绑定虚拟服务IP. 这时候如果客户端对于虚拟服务IP的arp请求广播到了各个真实服务器节点, 如果arp_ignore
配置为0,则各个真实服务器节点都会响应该arp请求,此时客户端就无法正确获取LVS节点上正确的虚拟服务IP所在网卡的MAC地址. 假如某个真实服务器节点A的网卡eth1
响应了该arp请求,客户端把A节点的eth1网卡的mac地址误认为是LVS节点的虚拟服务IP所在网卡的MAC, 从而将业务请求直接发送到了A节点的eth1网卡. 这时候虽然
因为A节点在环回网卡上绑定了虚拟服务IP,所以A节点可以正常处理请求,业务暂时不会受到影响. 但此时由于客户端请求没有发送到LVS的虚拟服务ip上,所以LVS的负载均衡能力没有生效.造成的结果就是,A节点一直在单节点运行, 业务量过大时可能会出现性能瓶颈
所以DR模式下要求 arp_ignorepe参数配置为1

2.arp_announce
每个机器或交换机都有一张arp表,该表用于存储对端通信节点IP地址和MAC地址的对应关系. 当收到一个未知IP地址的arp请求,就会在本机
的arp表中新增对端的ip和mac记录; 当收到一个已知IP地址(arp表中已有记录的地址)的arp请求,则会根据arp请求中的源MAC刷新自己的arp表.

    如果arp_announce配置为0,则网卡在发送arp请求时,可能选择的源ip地址并不是该网卡自身的IP地址,这时候收到该arp请求的其他节点或者交换机
上的arp表中记录的该网卡ip和MAC的对应关系就不正确,可能会引发一些未知的网路问题, 存在安全隐患
所以DR模式下要求 arp_announce配置为2.
'

:'
arp_ignore和arp_announce的配置
arp_ignore和arp_announce参数分别有all,default,lo,eth1,eth2等对应不同网卡的具体参数. 当all和具体
网卡的参数值不一致的话,取较大值生效
一般只需要修改all和某个具体网卡的参数即可(取决于你需要修改哪个网卡).下面以修改lo网卡为例:
 1. 修改/etc/sysctl.conf文件，然后sysctl -p刷新到内存。
 net.ipv4.conf.all.arp_ignore=1
 net.ipv4.conf.lo.arp_ignore=1
 net.ipv4.conf.all.arp_announce=2
 net.ipv4.conf.lo.arp_announce=2

 2. 使用sysctl -w直接写入内存：
 sysctl -w net.ipv4.conf.all.arp_ignore=1
 sysctl -w net.ipv4.conf.lo.arp_ignore=1
 sysctl -w net.ipv4.conf.all.arp_announce=2
 sysctl -w net.ipv4.conf.lo.arp_announce=2

 3. 修改/proc文件系统：
 echo "1">/proc/sys/net/ipv4/conf/all/arp_ignore
 echo "1">/proc/sys/net/ipv4/conf/lo/arp_ignore
 echo "2">/proc/sys/net/ipv4/conf/all/arp_announce
 echo "2">/proc/sys/net/ipv4/conf/lo/arp_announce
'