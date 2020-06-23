#!/usr/bin/expect -f
# 获取参数
set ip [lindex $argv 0 ]
# 设置超时时间
set timeout 10
# 登录机器
spawn ssh root@$ip
# 自动输入操作
expect {
# 如果出现 yes/no, 则输入yes
"*yes/no" { send "yes\r"; exp_continue}
# 输入出现password, 则输入密码
"*password:" { send "rootroot\r";exp_continue }
}
# 出现 # 字符,说明登录了
expect "#*"
# 发送命令; 命令后有 \r 字符,表示执行
send "systemctl stop zabbix-server\r"
# 退出
send  "exit\r"
# expect脚本结束
expect eof