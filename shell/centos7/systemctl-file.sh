如下所示，Systemd 服务的 Unit 文件可以分为三个配置区段:
Unit 和 Install 段：所有 Unit 文件通用，用于配置服务（或其它系统资源）的描述、依赖和随系统启动的方式
Service 段：服务（Service）类型的 Unit 文件（后缀为 .service）特有的，用于定义服务的具体管理和操作方法

[Unit]
Description: 描述这个Unit文件的信息
Documentation: 指定服务的文档,可以是一个或多个文档的URL路径
Requires: 依赖的其他Unit列表,列在其中的Unit模板会在这个服务启动时的同时被启动.
            并且如果其中任意一个服务启动失败,这个服务也会被终止
Wants: 与Requires类似,但只是在被配置的这个Unit启动时,触发启动列出的每个Unit模块,而不去考虑这些模块启动是否成功
After: 与Requires相似,但是在后面列出的所有模块全部启动完成后,才会启动当前服务
Before:与After相反,在启动列出的任一模块时,都会首先确保当前服务已经运行
BindsTo:与Requires相似,当时在这些模块中有任意一个出现意外结束或重启时,这个服务也会跟着终止或重启
PartOf: 一个BindsTo作用的子集,仅在列出的任务模块失败或重启时,终止或重启当前任务,而不会随列出模块的启动而启动
OnFailure: 当这个模块启动失败时,就会自动启动列出的每个模块
Conflicts: 与这个模块有冲突的模块,如果列出的模块中有已经在运行的,这个服务就 不能启动,反之亦然

[Service]
# 用来进行Service配置,只有Service类型的Unit才有这个区块.主要字段分为服务生命周期和服务上下文配置两个方面.
# 1. 服务生命周期控制
Type: 定义启动时的进程行为,有以下几种值:   
    Type=simple, 默认值,执行ExecStart指定的命令,启动主进程
    Type=forking,以fork方式从父进程创建子进程,创建后父进程立即退出
    Type=oneshot,一次性进程,Systemd会等当前服务退出,再继续往下执行
    Type=dbus, 当前服务通过D-Bus启动
    Type=notify, 当前服务启动完毕,会通知Systemd,再继续往下执行
RemainAfterExit: 值为true或false(默认). 当配置为true时,Systemd只会负责启动服务进程,之后即便服务进程退出了,
            Systemd也仍然会任务这个服务在运行中.这个配置主要是提供给一些并非常驻内存,而是启动注册后立即退出,
            然后等待消息按需启动的特殊类型服务使用的.
ExecStart:  启动当前服务的命令
ExecStartPre: 启动当前服务之前执行的命令
ExecStartPos: 启动当前服务之后执行的命令
ExecReload: 重启当前服务时执行的命令
ExecStop: 停止当前服务时执行的命令
ExecStopPost: 停止当前服务后执行的命令
RestartSec:自动重启当前服务间隔的秒数
Restart:定义何种情况Systemd会自动重启当前服务,可能的值包括always(总是重启),on-success,on-failure,on-abnormal,on-abort,on-watchdog
TimeoutStartSec: 启动服务时等待的秒数,这一配置对于使用Docker容器而言显得尤为重要,因其第一次运行时可能需要下载镜像,严重超时会容易被Systemd
                误判为启动失败杀死.通常,对于这种服务,将此值奢姿为0,关闭超时检测
TimeoutStopSec: 停止服务时等待的秒数,如果超过这个时间仍然没有停止,Systemd会使用SIGKILL信号强行杀死服务的进行.

# 2. 服务上下文配置
Enviroment: 为服务指定环境变量
EnviromentFile: 指定加载一个包含服务所需的环境变量的列表的文件,文件中每一行都是一个环境变量的定义
Nice: 服务的进程优先级,值越小优先级越高,默认为0.其中-20为最高优先级,19为最低优先级
WorkingDirectory: 指定服务的工作目录
RootDirectory: 指定服务进程的根目录(/目录).如果配置了这个参数,服务将无法访问指定目录以外的任何文件
User: 指定运行服务的用户
Group: 指定运行服务的用户组
MountFlags: 服务的Mount Namespace配置,会影响进程上下文中挂载点的信息,即服务是否会继续主机上已有挂载点,以及如果
            服务运行了挂载或卸载设备的操作,是否会真实地在主机上产生效果,可选值为shared,slaved,private
            shared: 服务与主机公用一个Mount Namespace,继承主机挂载点,且服务挂载或卸载设备会真实地反映到主机上
            slaved: 服务使用独立的Mount Namespace,它会继承主机挂载点,但服务队挂载点的操作只有在自己的Namespace内生效,
                    不会反映到主机上
            private: 服务使用独立的Mount Namespace,它在启动时没有任何挂载点,服务队挂载点的操作也不会反映到主机上.
LimitCPU/LimitSTACK/LimitNOFILE/LimtNPROC: 限制特定服务的系统资源量,例如cpu,程序堆栈,文件句柄数,子进程数量等.
# 注意:
:<<1
如果在ExecStart,ExecStop等属性中使用了Linux命令,则必须要写出完成的绝对路径.对于ExecStartPre
和ExecStartPost辅助命令,若前面有个 "-" 符号,表示忽略这些命令的出错.因为有些辅助命令本来就不一定能
成功, 比如尝试情况一个文件,但文件可能不存在.
1

[Install]
# 这部分配置的目标模块通常是特定运行目标的.target文件,用来使得服务在系统启动时自动运行.包含三中全自动约束
WantedBy: 和Unit段的Wants作用相似,只是后面列出的不是服务所依赖的模块,而是依赖当前服务的模块.它的值时一个或
        多个Target,当前Unit激活时(enable)符号链接会放入/etc/systemd/system目录下以<target名字>+.wants后缀
        构成的子目录中， 如: /etc/systemd/system/multi-user.target.wants
RequiredBy: 和Unit段的Wants作用相似,只有后面列出的不是服务所依赖的模块,而是依赖当前服务的模块.它的值时一个或多个
        Targer,当前Unit激活时,符号链接或放入/etc/systemd/system目录下以<Targer名>+.required 后缀构成的子目录中
Also:   当前Unit  enable/disable时, 同时 enable/disable的其他Unit
Alias:  当前Unit可用于启动的别名


Unit文件占位符
在Unit文件中,有时会需要使用到一些与运行环境有关的信息,例如节点ID, 运行服务的用户等.这些信息可以使用占位符来表示,
然后在实际运行时被动态地替换为实际的值.
%n: 完成的Unit文件名,包括.service后缀
%p: Unit模板文件名中@符号之前的部分,不包括@符号和.service后缀
%i: Unit模板文件名中@符号之后的部分,不包括@符号和.service后缀
%t: 存放系统运行文件的目录,通常是run
%u: 存放运行服务的用户,如果Unit文件中没有指定,则默认是root
%U: 运行服务的用户ID
%h: 运行服务的用户Home目录,即%{HOME} 环境变量的值
%s: 运行服务的用户默认Shell类型,即%{SHELL}环境变量的值
%m: 实际运行节点的Machine ID,对于运行位置每个服务的比较有用
%b: Boot ID,这是一个随机数,每个节点各不相同,并且每次节点重启时都会改变
%H: 实际运行节点的主机名
%v: 内核版本,即 uname -r 命令输出的内容
%%: 在Unit模板文件中表示一个普通的百分号

Unit管理
# 列出正在运行的Unit
systemctl list-units
# 列出所有的Unit,包括没有找到配置文件或者启动失败的
systemctl list-units --all
# 列出所有没有运行的unit
systemctl  list-units --all --state=inactive
# 列出所有加载失败的Unit
systemctl  list-units --failed
# 列出所有正在运行的,类型为 service的Unit
systemctl  list-units --type=service
# 查看Unit配置文件的内容
systemctl cat docker.service
# 杀死一个服务的所有子进程
systemctl kill appche.service
# 显示某个Unit的所有底层参数
systemctl show httpd.servive
# 显示某个Unit的指定属性的值
systemctl show -p CPUShared httpd.service
# 设置某个Unit的指定属性值
systemctl set-property httpd.service CPUShared=500
# 列出一个Unit的所有依赖,默认不会列出target类型
systemctl list-dependencies nginx.service
# 列出一个Unit的所有类型,包括target类型
systemctl list-dependencies --all nginx.service


Target管理
#查看当前系统所有的target
systemctl list-unit-files --type=target
# 查看一个Target包含的所有Unit
systemctl list-dependencies multi-user.target
# 查看启动时默认的target
systemctl get-default
# 奢姿默认的target
systemctl set-default multi-user.target
# 切换target时,默认不关闭前一个target启动的进行,
#systemctl isolate改变这种行为,关闭前一个Target里面所有不属于后一个target的进程
systemctl isolate multi-user.target

日志管理
# 查看所有日志(默认情况下,只保存本次启动的日志)
journalctl 
# 查看内核日志(不显示应用日志):--demage 或 -k
journalctl  -k
# 查看系统本次启动日志(其中包括了内核日志和各类系统服务的控制台输出): --system 或 -b
journalctl -b
journalctl -b -0
# 查看上一次启动的日志
journalctl -b -1
# 查看指定服务的日志: --unit 或 -u
journalctl -u docker.service
journalctl -u docker.service --since today
# 合并显示多个Unit的日志
journalctl -u nginx.service -u php-fpm.service --since today
# 查看指定服务的日志
journalctl /usr/lib/systemd/sustemd
# 实时滚动显示最新日志
journalctl -f
# 实时滚动某个Unit的最新日志
journalctl -f -u docker.service
# 查看指定时间的日志
journalctl --since="2020-10-30 18:17:16"
journalctl --since="20 min age"
journalctl --since yesterday
journalctl --since "2020-01-10" --until "2020-12-20 03:00"
journalctl --since 09:00 --until "1 hour age"
# 显示尾部最新10行日志:--lines 或 -n
journalctl -n
# 显示尾部指定行数的日志
journalctl -n 20
# 将最新的日志显示在前面
journalctl -r -u docker.service
# 改变输出的格式:--output 或 -o
journalctl -r -u docker.service -o json-pretty
#查看指定进程的日志
journalctl _PID=1
# 查看某个路径的脚本的日志
journalctl /bin/bash
# 查看指定用户的日志
journalctl _UID=33 --since today

:<<a
优先级
0:emerg
1:alert
2:crit
3:err
4:warning
5:notice
6:info
7:debug
a
#查看指定优先级的日志
journalctl -p err -b
# 以json格式输出日志
journalctl -b -u nginx.service -o json
# 显示日志占用的磁盘空间
journalctl --disk-usage
# 指定日志文件占据的最大空间
journalctl --vacuum-size=1G
# 指定日志文件保存多久
journalctl --vacuum-time=1years

Systemd 工具集
systemctl: 用于检查和控制各种系统服务和资源的状态
bootctl: 用于查看和管理系统启动分区
hostnamectl:用于查看和修改系统的主机名和主机信息
journalctl: 用于查看系统日志和各类应用服务日志
localectl: 用于查看和管理系统的地区信息
loginctl:用于管理系统已登录用户和Session的信息
machinectl: 用于操作Systemd容器
timedatectl: 用于查看和管理系统的时间和时区信息
systemed-analyze:显示此次系统启动时运行每个服务所消耗的时间,可以用于分析系统启动过程中的性能瓶颈
systemd-ask-password:辅助工具,用星号屏蔽用户的任一输入,然后返回实际输入的内容
systemd-cat: 用于将其他命令的输出重定向到系统日志
systemd-cgls:递归显示指定CGroup的继承链
systemd-cgtop: 显示系统当前最好资源的CGroup单元
systemd-escape: 辅助性工具,用于去除指定字符串中国不能作为Unit文件名的字符
systemd-hwdb: Systemd内部工具，用于更新硬件数据库
systemd-delta: 对比当前系统配置与默认系统配置的差异
systemd-detect-virt:显示主机的虚拟化类型
systemd-inhibit: 用于强制延迟或禁止系统关闭，睡眠和待机事件
systemd-machine-id-setup: Systemd的内部工具，用于给Systemd容器生成ID
systemd-notify:Systemd的内部工具，用于通知服务的状态变化
systemd-nspawn:用于创建Systemd容器
systemd-path: Systemd内部命令,用于显示系统上下文中的各种路径配置
systemd-run: 用于将任意指定的命令包装成一个临时后台服务运行
systemd-stdio-bridge:Systemd的内部工具,用于将程序的标准输入输出重定向到系统总线
systemd-tmpfiles: Systemd的内部工具,用于创建和管理临时文件目录
systemd-tty-ask-password-agent: 用于响应后台服务进程发出的输入密码请求

Systemctl
# 系统重启
systemctl reboot
# 关闭系统,切断电源
systemctl poweroff
# CPU 停止工作
systemctl halt
# 暂停系统
systemctl suspend
# 系统进入冬眠状态
systemctl hibernate
# 系统进入交互式休眠状态
systemctl hybrid-sleep
# 进入救援状态(单用户)
systemctl rescue


systemd-analyse
# 查看启动耗时
systemd-analyse 
# 查看每个服务的启动耗时
systemd-analyse blame
# 显示瀑布状的启动过程流
systemd-analyse critical-chain
# 显示指定服务的启动流
systemd-analyse critical-chain atd.service


hostnamectl
# 显示主机名
hostnamectl
# 设置主机名
hostnamectl set-hostname rhel7

timedatectl
# 查看当前时区设置
timedatectl
# 显示所有可用的时区
timedatectl --list-timezones
# 设置当前时区
timedatectl set-timeznoe America/New_York
timedatectl set-time YYYY-MM-DD
timedatectl set-time HH:MM:SS


[loginctl]
# 列出当前session
loginctl list-sessions
# 列出当前登录用户
loginctl list-users 
# 列出显示指定用户的信息
loginctl show-user runyf


[systemd-run]
systemd-run可以将一个指定的操作变成后台运行的服务. 它的效果与直接在命令后加上&符号很类似.然而,它让
命令成为服务还意味着,它的声明周期由Systemcd控制. 包括但不仅限于以下好处:
1. 服务的声明周期由systemd接管,不会随着启动它的控制台关闭而结束
2. 可以通过systemctl工具管理服务的状态
3. 可以通过journalctl工具查看和管理服务的日志信息
4. 可以通过Systemd提供的方法限制服务的cpu,内存,磁盘IO等系统资源的使用情况

