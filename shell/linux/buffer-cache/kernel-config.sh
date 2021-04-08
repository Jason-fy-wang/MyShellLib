# linux kernel配置 command
sysctl 

# 1. 查看系统中的配置
    sysctl -a : 查看所有根目录下的内核参数
    sysctl varable: 查看指定的内核参数

# 2. 设置系统配置
    sysctl -w  var=value: 设置内核参数var等于value

# 3. 通过 /proc 文件系统设置
# 通过把值写入到 对应的配置的文件,来修改参数
 ehco "value" > /proc/sys/path/var_file

# 上面三种修改配置的方式时即时生效 不过只是暂时的,系统重启后 就失效了

# 4. 修改配置,此会永久生效
 /etc/sysctl.conf  
 /etc/sysctl.d/*.conf



