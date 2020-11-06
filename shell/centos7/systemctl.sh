# 分析启动时各个进程花费的时间
systemd-anayze blame

# 分析启动时的关键链
systemd-analyze critical-chain

# 列出所有可用单元
systemctl list-unit-files

# 列出所有运行中的单元
systemctl list-units

# 列出所有失败的单元
systemctl --failed

# 检测某个服务是否开机启动
systemctl is-enabled crond.service


# 列出所有服务
systemctl list-unit-files --type=service

# 列出所有系统挂载点
systemctl list-unit-files --type=mount

# 列出所有可用系统套接口
systemctl list-unit-files --type=socket

# 屏蔽(让他不能启动)可见挂载点
systemctl mask tmp.mount
systemctl unmask tmp.mount

systemctl mask cups.socket
systemctl unmask cups.socket


# 显示服务的cpu分配额
systemctl show -p CPUShares httpd.service

# 设置服务的cpu分配额
systemctl set-property httpd.service CPUShares=2000

# 查看服务的cpu分配额
vi /etc/systemd/system/httpd.service.d/90-CPUShares.conf 

# 查看服务的所有配置细节
systemctl show httpd

# 分析某个服务的关键链
systemd-analyze critical-chain httpd.service

# 列出某个服务的依赖性列表
systemctl list-dependencies httpd.service

# 按等级列出控制组
systemd-cgls

# 按cpu 内存 输入 输出列出控制组
systemd-cgtop

#救援模式
systemctl rescue

# 紧急模式
systemctl emergency

# 列出当前运行等级
systemctl get-default


# 运行等级5
systemctl isolate runlevel5.target
systemctl isolate graphical.target

# 重启  停止 挂起  休眠  进入混合睡眠
systemctl reboot
systemctl halt
systemctl suspend
systemctl hibernate
systemctl hybrid-sleep


 Runlevel 0 : 关闭系统
 Runlevel 1 : 救援？维护模式
 Runlevel 3 : 多用户，无图形系统
 Runlevel 4 : 多用户，无图形系统
 Runlevel 5 : 多用户，图形化系统
 Runlevel 6 : 关闭并重启机器
