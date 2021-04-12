## iptables 传输数据包的过程, 如图: iptable_chain.png
1. 当一个数据包进入网卡时, 它首先会进入PREROUTING链, 内核根据数据包目的IP判断是否需要转发出去
2. 如果数据包就是进入本机的, 它就会沿着图示向下移动,到达INPUT链. 数据包到了INPUT链后,任何进程都会接收到它.
   本机上运行的程序可以发送数据包,这些数据包会经过OUTPUT链,然后到达POSTROUTING链输出.
3. 如果数据包是要转发出去的,且内核允许转发,数据包就会如图示所示向右移动,经过FORWARD链,然后到达POSTROUTING链输出

## 五个规则链
1. PREROUTING(路由前)
2. INPUT (数据包入口)
3. FORWARD (转发)
4. OUTPUT (数据包出口)
5. POSTROUTING(路由后)

## 常用的表
1. filter: 定义允许或不允许的过滤规则
2. nat: 定义地址转换
3. mangle: 修改报文源数据.

## iptables命令格式
### 语法结构
iptables [-t table]  comamnd [chain] [rules] [-j target]
table  -- 指定 表名
command -- 对链的操作命令 
chain   -- 链名
rules   -- 规则
target  -- 进行何种action

#### 1.表选项
表选项用于指定命令应用于哪个iptables内置表, iptables内置表包括:filter, nat, mangle,raw

#### 2.命令选项
-P | --policy <链名>  -- 定义默认策略
-L | --list <链名>    -- 查看iptables规则列表
-A | --append <链名>  -- 在规则列表的最后增加规则
-I | --insert <链名>  -- 在之地那个位置插入1条规则
-D | --delete <链名>  -- 从规则列表中删除1条规则
-R | --replace <链名> -- 替换规则列表中的某条规则
-F | --flush <链名>   -- 删除表中所有规则
-Z | --zero <链名>    -- 将表中数据包计数器和流量计数器归零
--line-number         --显示规则的行号

#### 3.匹配选项
-i | --in-interface <网络接口名>  --- 指定数据包从哪个网口接口进入,如eth0,ppp0等
-o | --out-interface <网络接口名> --- 指定数据包从哪个网络接口输出,如ppp0, eth0,eth1等
-p | --protocol <协议类型>        --- 指定数据包匹配的协议,如tcp,udp和icmp等
-s | --source <源地址或子网>      --- 指定数据包匹配的源地址
-sport  <源端口号>                --- 指定数据包匹配的源端口号,可以使用'起始端口号:结束端口号'的格式指定一个范围的端口
-d | --destination <目标地址或子网>--- 指定数据包匹配的目标地址
-dport <目标端口号>                --- 指定数据包匹配的目标端口号,可以使用"起始端口号:结束端口号"的格式指定要给范围的端口

#### 4.动作选择
ACCEPT   -- 接收数据包
DROP     -- 丢弃数据包
REDIRECT 与 DROP 一样, 区别在于它除了阻塞包之外,还向发送者返回错误信息
SNAT    -- 源地址转换,即改变数据包的源地址
DNAT    -- 目标地址转换,即改变数据包的目的地址
MASQUERADE -- IP伪装,即常说的NAT技术, MASQUERADE只能用于ADSL等拨号上网的IP伪装,也就是主机的IP是由ISP动态分配的;
            如果主机的IP地址是静态固定的, 纪要使用SNAT
LOG        -- 日志功能,将符合规则的数据包相关信息记录在日志中,以便管理员的分析和排错

## 1. 定义默认策略
当数据包不符合链中任意一条规则时,iptables将根据该链预先定义的默认策略来处理数据包,默认策略
定义如下:
iptables [-t table] <-P> <链名> <action> 
[-t table] :指默认策略将应用于哪个表,可以使用filter,nat,mangle. 如果没有指定使用哪个表,iptables默认使用filter表
<-P> : 定义默认策略
<链名> : 指默认策略将应用于哪个链,可以使用INPUT,OUTPUT,FORWARD,PREROUTING,POSTROUTING.
<action>: 处理数据包的动作,可以使用ACCEPT(接收数据包) 和 DROP (丢弃数据包)

## 2. 查看iptables规则
查看iptables规则:
iptables [-t table] <-L> [链名]
[-t table]: 指查看哪个表的规则列表,表明可以使用filter,nat,mangle; 如果没有指定,iptables就默认查看filter表规则列表
<-L> : 查看指定表和指定链的规则列表
[链名] : 指查看指定表中哪个链的规则列表,可以使用INPUT,OUTPUT,FORWARD,PREROUTING,POSTROUTING; 如果不指定链,则将查看某个表中所有
        链的规则列表

## 3. 增加,插入,删除和替换规则
操作规则的命令格式:
iptables [-t table]  <-A|I|D|R>  链名 [规则编号] [-i|o 网卡名称] [-p 协议类型] [-s 源ip地址|源子网]  [--sport 源端口] [-d 目标ip|目标子网] [--dport 目标端口号] <-j action>
参数:
[-t table]: 指定对哪个表进行操作,可以是 filter,nat,mangle; 如果没有指定表,默认操作filter
-A: 新增一条规则,该规则将会增加到规则列表的最后一行,该参数不能使用规则编号
-I: 插入一条规则, 原本该位置上的规则将会往后顺序移动, 如果没有指定规则编号,则在第一条规则前插入
-D: 从规则列表中删除一条规则,可以输入完整规则,或直接指定规则编号加入删除
-R: 替换某条规则,规则被替换并不会改变顺序,必须要指定替换的规则编号

链名: 指定操作哪条链的规则列表,可以使用INPUT,OUTPUT, PREROUTING,POSTROUTING,FORWARD.
[规则编号]: 规则编号用于插入,删除和替换时使用. 编号是按照规则列表的顺序排列,规则列表中第一条规则为1
-i 网卡名称: 指定数据包从哪块网卡进入
-o 网卡名称: 指定数据包从哪块网卡出去
-p 协议 : 指定规则应用的协议, 包含 TCP,UDP,ICMP等
-s 源ip|子网 : 数据包源主机的ip地址 或 子网地址
--sport 源端口号: 数据包ip的源端口号
-d 目标ip|目标子网: 数据包目标主机的ip地址或子网地址
--dport 目标端口号: 数据包的目标端口号
<-j action> : 处理数据的动作


## 4. 清除规则和计数器清零
在新建规则时,往往需要清除原有的,旧的规则, 以免它们影响新设定的规则. 如果规则比较多,一条一条删除就十分麻烦,这时
可以使用iptables提供的清除规则参数可以达到快速删除所有规则的目的.
iptables [-t  table]  <-F|-Z>
[-t table]: 指定哪个表，可以是: filter  nat  mangle
-F: 删除指定表中所有规则
-Z: 将指定表中的数据包计数器和流量计数器归零.

## 5. 规则保存
iptables-save > /etc/sysconfig/iptables

iptables-restore < /etc/sysconfig/iptables

## 7. 参数分类解析
#### 1. 链管理命令
-P: 设置默认策略(设置默认策略是drop/accept)
        默认策略一般只有两种:
        iptables -P INPUT (DROP|ACCEPT) 默认是drop/accept
        如:
        iptables -P INPUT DROP -- 默认规则是drop,并且没有定义哪个动作,所以关于外界连接的所有谷子额包括xshell连接之类的都被拒绝了
-F: flush, 清空规则链
        iptables -t nat -F PREROUTING  清空nat表的PREROUTING 链
        iotables -t nat -F  清空nat表的所有链
-N: NEW 支持用户新建要给链
        iptables -N inbound_tcp_web 表示附在tcp上用于检查web的链
-X: 用于删除用户自定义的空连
        使用方法跟-N 相同, 但是在删除前必须将里面的链给清空了
-E: 用来rename chain,主要是用于给用户自定义的链重命名
        -E olename  newName
-Z: 清空链及链中默认规则的计数器.(由两个计数器,数据包激素去和字节计数器)

#### 2. 规则管理命令
-A: 追加,在当前链的最后新增一个规则
-I num: 插入,把当前规则插入为第几条
        -I 3: 把当前规则插入为 第三条
-R num: 替换/修改第几条规则
-D num: 删除,明确指定删除第几条规则

#### 3. 查看规则的 命令 -L
附加子命令:
-n:  以数字的方式显示IP,它会将ip直接显示出来,如果不加-n,则会将ip反向解析成主机名
-v: 显示详细信息
-vv:
-vvv:
-x: 在计数器上显示精确值,不做单位换算
--line-numbers: 显示规则的行号
-t nat : 指定要显示的表,这里显示  nat表的规则

## 8. 解析匹配标准
#### 1. 通用匹配:源地址和目标地址的匹配
-s: 指定作为源地址匹配,这里不能指定主机名称,必须是IP | IP/MASK | 0.0.0.0/0.0.0.0. 而且地址可以取反,加一个 ! 表示除了哪个IP以外
-d: 表示匹配目标地址
-p: 用于匹配协议(这里协议通常由三种: TCP/UDP/ICMP)
-i eth0: 从eth0网卡流入的数据.流入一般用在INPUT和PREROUTING 上
-o eth0: 从这块网卡流出的数据,流出一般用在OUTPUT和POSTROUTING上

#### 2. 扩展匹配
##### 2.1 隐含扩展,对协议的扩展
-p tcp: TCP 协议的扩展,一般由三种扩展
--dport xx-xx: 指定目标端口,不能指定多个非连续端口,只能指定单个端口,如: --dport 21 或者 --dport 21-23(表示:21 22 23)
--sport : 指定源端口
--tcp-flags: TCP的标志位(SYN ACK FIN PSH RST URG),对于此,一般要跟两个参数:1. 检查的标志位 2. 必须为1的标志位
如:  --tcp-flags syn,ack,fin,rst  syn  -- 表示检查syn,ack,fin,rst这4个位,其中 syn必须为1, 其他必须为0.所以这个意思就是用于检测三次握手的第一次包.对于这种专门匹配syn为1的包,还由一种简写为:  --syn
 
-p udp: UDP协议的扩展
        --dport
        --sport
-p icmp : icmp数据报文的扩展
        --icmp-type:
                echo-request(请求回显),一般用8来表示.所以 --icmp-type 8 匹配请求回显数据包
                echo-reply(响应的数据包): 一般用0来表示

##### 2.2 显示扩展
扩展各种模块:
        更多可以查看帮助 man 8 iptables-extensions
        -m multiport: 表示启动多端口扩展,之后就可以启用: --dports 21,23,80
        
## 8. 详解 -j ACTION
常用的ACTION:
DROP: 悄悄丢弃,一般多用DROP来隐藏身份,以及隐藏链表
REJECT: 明确表示拒绝
ACCEPT: 接收
DNAT: 目标地址转换
SNAT: 源地址转换
MASQUERADE: 源地址伪装
REDIRECT: 重定向,主要用于实现端口重定向
MARK: 打印防火墙标记
RETURN: 返回. 在自定义链指定完毕后使用返回, 来返回原规则链

## 6. 帮助
man iptables
man 8 iptables-extensions (各种扩展)

## iptables example
### ex1 添加iptables规则,禁止用户访问域名www.sey.com
iptables -I FORWARD -d  www.sey.com  -j DROP

### ex2 添加iptables规则,禁止用户访问ip地址为20.20.20.20的网站
iptables -I FORWARD -d 20.20.20.20 -j DROP

### ex3 添加iptables规则,禁止ip地址为192.168.1.x的客户机上网
iptables -I FORWARD -s 192.168.1.x -j DROP

### ex4 添加iptables规则,禁止192.168.1.0子网所有的客户机上网
iptables -I FORWARD -s 192.168.1.0/24 -j DROP

### ex5 禁止192.168.1.0子网所有客户机使用FTP 协议下载
iptables -I FORWARD -s 192.168.1.0/24 -p TCP --dport 21 -j DROP

### ex6 禁止192.168.1.0子网所有的客户机使用Telnet协议连接远程计算机
iptables -I FORWARD -s 192.168.1.0/24 -p tcp --dport 23 -j DROP

### ex7 强制所有的客户机访问192.168.1.x 这台web机器
iptables -t nat -I PREROUTING -i eth0 -p tcp --dport 80  -j DNAT --to-destination 192.168.1.x:80

### ex8 禁止internet上的计算机通过ICMP协议ping到NAT服务器的ppp0接口,但允许内网的客户机通过ICMP协议ping计算机
iptables -I INPUT -i ppp0 -p icmp -j DROP

### ex9 发布内网10.0.0.3主机的web服务,internet用户通过访问防火墙的IP地址即可访问该主机的web服务
iptables -t nat -I PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.0.3:80

### ex10 发布内网10.0.0.3主机的终端服务(使用的是TCP协议的3389端口),internet用户通过访问防火墙的IP地址访问该主机的终端服务
iptables -t nat -I PREROUTING -p tcp --dport 2289 -j DNAT --to-destination 10.0.0.3:3389


### ex11 只要是来自172.16.0.0/16网段的都允许访问本机的172.16.100.1的sshd服务
修改默认策略:
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# 分析:因为不需要做地址转换,所以定义在filter表即可
iptables -t filter -A INPUT -s 172.16.0.0/16 -d 172.16.100.1 -p tcp --dport 22 -j ACCEPT
iptables -t filter -A OUTPUT -s 172.16.100.1  -d 172.16.0.0/16 -p tcp --dport 22 -j ACCEPT

### ex12 状态检测
:'
状态检测是一种显示扩展,用于检测会话之间的连接关系
对于整个TCP协议来讲,它是一个有连接的协议,三次握手中,第一次握手,我们叫做NEW连接,从第二次握手以后的,ack都为1,这是正常的数据传输,和tcp的第二次第三次握手,叫做已建立的连接(ESTABLISHED); 还有一种状态比较诡异的,如:SYN=1,ACK=1,RST=1,对于这种我们无法识别的,我们都称之为INVALID. 还有第四种,FTP这种古老的协议拥有的特征,每个端口都是独立的,21号和20号都是一去一回,它们之间是有关系的,这种关系我们 称之为 RELATED.
所以状态一共有四种:
NEW
ESTABLISHED
RELATED
INVALID
UNTRACKED : 未追踪的连接
'
针对ex11,可以增加状态检测. 比如只允许状态为ESTABLISHED进来,出去只允许ESTABLISHED状态出去, 默认规则都使用拒绝.
iptables -L -n --line-numbers : 查看之前的规则位于第几行
修改INPUT:
iptables -R INPUT 2 -s 172.16.0.0/16 -d 172.16.100.1 -p tcp --dport 22 -m state --state NEW,ESTABLISHED  -j ACCEPT

修改OUTPUT:
iptables -R OUTPUT 1 -m state --state ESTABLISHED -j ACCEPT

# 再放行一个80端口
iptables -A INPUT -d 172.16.100.1 -p tcp  --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

### ex13 允许自己ping别人, 但是别人ping自己就ping不同
# 分析:对于ping这个协议,进来的为8(ping),出去的为0(响应). 我们为了达到目的,需要8出去,允许0进来
# 在出去的端口上
iptables  -A OUTPUT -p icmp --icmp-type 8 -j ACCEPT
# 在进来的端口上
iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT

## 针对127.0.0.1 比较特殊,需明确定义
iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A OUTPUT  -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT

### ex13 SNAT 针对源地址的转换
基于源地址的转换一般用在许多内网用户通过一个外网的口上网的时候, 这时我们将内网的地址转换为一个外网的IP,我们就可以实现连接其他外网
IP的功能.
如: 现在要将所有192.168.10.0 网段的IP在经过的时候全部转换为172.16.100.1整个外网地址:
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SNAT --to-source 172.16.100.1
这样只要是来自192.168.10.0网段的主机通过此网卡访问网络的,源地址都会被转换成172.10.100.1 整个IP.

## 问题升级: 如果172.10.100.1 不是固定的怎么办?
我们都知道当我们使用运营商上网的时候,一般它都会在每次你开机的时候随机生成一个外网ip,意思就是外网地址是动态转换的. 这时我们就要将外网地址
换成MASQUERADE(动态伪装): 它可以实现自动寻找到外网地址,而自动将其修改为正确的外网地址.
itables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE

### ex14 DNAT 针对目标地址的转换
对于目标地址的转换,数据流是从外向内的,外面的是客户端,里面的是服务器端, 通过目标地址转换,我们可以让外面的
ip通过我们对外的外网IP来访问我们的服务, 而我们的服务却放在内网不同的服务器上.
如何做目标地址转换呢?
iptables -t nat -A PREROUTING -d 192.168.10.18 -p tcp --dport 80 -j DNAT --to-destination 172.16.100.2
        目标地址转换要在到达网卡之前转换, 所以要在 PREROUTING 链上.



