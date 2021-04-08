global_defs {
   router_id zabbix1      #router_id 机器标识，通常为 hostname ，但不一定非得是 hostname 。
}
vrrp_script chk_zabbix {        # 定义检测的脚本 
  script "/etc/keepalived/check.sh zabbix-server"
  interval 2
  weight 30
  fall 2        # 尝试两次都失败才失败
  rise 2        # 尝试两次都成功才成功
}
vrrp_script chk_mysql { # 定义检测的脚本
  script "/etc/keepalived/check.sh mysqld"
  interval 2
  weight 20
  fall 2        # 尝试两次都失败才失败
  rise 2        # 尝试两次都成功才成功
}
vrrp_instance VI_1 {            #vrrp 实例定义部分
    state MASTER               # 设置 lvs 的状态， MASTER 和 BACKUP 两种，必须大写
    interface eth0               # 设置对外服务的接口
    virtual_router_id 100        # 设置虚拟路由标示，这个标示是一个数字，同一个 vrrp 实例使用唯一标示
    priority 100               # 定义优先级，数字越大优先级越高，在一个 vrrp——instance 下， master 的优先级必须大于 backup
    advert_int 1              # 设定 master 与 backup 负载均衡器之间同步检查的时间间隔，单位是秒
    authentication {           # 设置验证类型和密码
        auth_type PASS         # 主要有 PASS 和 AH 两种
        auth_pass 1111         # 验证密码，同一个 vrrp_instance 下 MASTER 和 BACKUP 密码必须相同
    }
    track_interface {
        eth0
    } 
    virtual_ipaddress {        
        10.1.100.33 dev eth0 label eth0:1 # 设置虚拟 ip 地址，可以设置多个，每行一个
    }
    unicast_src_ip  10.1.100.31  #本端IP
    unicast_peer {              
        10.1.100.32 #对端IP
    }
    track_script {  # 调用前面定义的脚本
        chk_zabbix
        chk_mysql
    }
notify_master "/etc/keepalived/zabbix.sh" # 指定当切换到 master 时，执行的脚本
notify_backup "systemctl stop zabbix-server" # 指定当切换到 backup 时，执行的脚本
}

	虚机2配置如下
vi /etc/keepalived/keepalived.conf

global_defs {
   router_id zabbix2      #router_id 机器标识，通常为 hostname ，但不一定非得是 hostname 。
}
vrrp_script chk_zabbix {
  script "/etc/keepalived/check.sh zabbix-server"
  interval 2
  weight 5
  fall 2        # 尝试两次都失败才失败
  rise 2        # 尝试两次都成功才成功
}
vrrp_script chk_mysql {
  script "/etc/keepalived/check.sh mysqld"
  interval 2
  weight 45
  fall 2        # 尝试两次都成功才成功
  rise 2        # 尝试两次都失败才失败
}
vrrp_instance VI_1 {            #vrrp 实例定义部分
    state BACKUP               # 设置 lvs 的状态， MASTER 和 BACKUP 两种，必须大写
    interface eth0              # 设置对外服务的接口
    virtual_router_id 100        # 设置虚拟路由标示，这个标示是一个数字，同一个 vrrp 实例使用唯一标示
    priority 90               # 定义优先级，数字越大优先级越高，在一个 vrrp——instance 下， master 的优先级必须大于 backup
    advert_int 1              # 设定 master 与 backup 负载均衡器之间同步检查的时间间隔，单位是秒
    authentication {           # 设置验证类型和密码
        auth_type PASS         # 主要有 PASS 和 AH 两种
        auth_pass 1111         # 验证密码，同一个 vrrp_instance 下 MASTER 和 BACKUP 密码必须相同
    }
    track_interface {
        eth0
    } 
    virtual_ipaddress {        
        10.1.100.33 dev eth0 label eth0:1 # 设置虚拟 ip 地址，可以设置多个，每行一个
    }
    unicast_src_ip  10.1.100.32  #本端IP
    unicast_peer {              
        10.1.100.31  #对端IP
    }
    track_script {      # 调用前面定义的脚本
        chk_zabbix
        chk_mysql
    }
notify_master "/etc/keepalived/zabbix.sh" # 指定当切换到 master 时，执行的脚本
notify_backup "systemctl stop zabbix-server" # 指定当切换到 backup 时，执行的脚本
 #notify_fault "/etc/keepalived/notify.sh fault"
}
