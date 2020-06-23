#!/usr/bin/expect

# 读取参数
set name [lindex $argv 0]
set age [lindex $argv 1]

# 打印参数
puts $argv
puts $name
puts $age



# 运行方式   expect expect1.sh zhangsan 4



##################方式二#############################
#!/usr/bin/expect
# 此脚本和上面的输出是一样的
set name [lrange $argv 0 0]
set age [lrange $argv 1 1]
puts $argv
puts $name
puts $age


##################lrange另一种用法
#!/usr/bin/expect
# 读取参数
# 此时 name的值为参数0 和参数1 
set name [lrange $argv 0 1]
set age [lrange $argv 1 1]
# 打印参数
puts $argv
puts $name
puts $age

输出:
[root@name3 opt]# expect expect1.sh zhangsan 4
zhangsan 4
zhangsan 4
4

