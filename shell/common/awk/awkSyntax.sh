#!/bin/bash

# 1.某个字段的操作:基本数学运算(加减乘除,取余),逻辑运算(大于 小于 大于等于 小于等于 等于 或 与 非) 正则匹配(~=)  等
<<!
#如果 第5个字段和2取余为0,则进行打印
awk '{if ($5 % 2==0) } print $5}'
!

# ***************if语句***************
## 打印出能被2整除 且 包含2 的数字
seq 0 10 | awk '{if ($1%2==0 && $1 ~= 2) {print $2}}'


### 对成绩进行分组
seq 0 10 100 | awk '{
    if ($1 >= 90) {print $1,"very good."} 
    else if($1 >= 80) {print $1,"good.."}
    else if ($1 >= 60) {print $1, "work harder."}
    else {print $1,"never give up,you can do it."}
    }'

# ***************awk语言编写脚本***************
<<!
#!/usr/bin/awk -f
BEGIN{
    for(i=0;i<10;i++){
    print "hello",i
    }
}

!

# ***************数组***************

## 打印数组
# 其中遍历时 key是数组的索引, a[key] 才是对应的值
# a[$1]=$4 这就是定义素组了,当然数组也有二维数组
df | awk '{NR !=1;a[$1]=$4} END {for(key in a){print key,"\t",a[key]}}'
<<!
for(i in arr){
    print i,arr[i]
}
!
# ***************for语句***************
awk 'BEGIN{for(i=0;i<10;i++){print i}}'

# ***************while语句***************
awk 'BEGIN{i=0; while(i<10) {print i;i++}}'

# ***************自定义函数***************
<<!
function 函数名(参数) {指令序列}
!
# 输出招呼
awk 'function mprint(msg){print "hello",msg} BEGIN{mprint("tom")}'

# 对比大小
awk 'function max(x,y){if (x > y) {print "max is", x} else {print "max is",y}} BEGIN{max(10,15)}'

# ***************内置函数***************
# 算数函数
atan2(y,x)      # 返回y/x的反正切
cos(x)          # 返回x的余弦,x是弧度
sin(x)          # 返回x的正弦,x是弧度
exp(x)          # 返回x幂函数
log(x)          # 返回x的自然对数
sqrt(x)         # 返回x平方根
int(x)          # 返回x的截断至整数的值
rand()          # 返回任意数组n,其中 0<=n<1
srand(seed)     # 将rand函数的种子值设置为seed参数值,如果省略seed参数,则使用某天的时间.

# 字符串函数
gsub(regex,substr, string)      # gsub是全局替换(global substitution).
sub(regex,substr, string)       # sub函数执行一次子串替换,它将第一次出现的子串用regex替换,第三个参数是可选的,默认为$0
substr(str, start,length)       # substr返回str字符串从start开始长度为length的子串.如果没有指定length的值,返回str从第start开始的子串
index(string,sub)   # 在string中查找sub子串的位置. 从1开始编号,如果不存在则返回0
length(string)     # 返回string参数的长度. 如果参数未给,则返回$0的长度
blength([string])   # 返回string的长度(以字节为为单位). 如果未给出参数,则返回$0的长度
match(string, regex) # 在string中返回regex正则匹配的字符的开始位置.从1开始编号. 如果没有匹配,则返回0;
注意: RSTART特殊变量 表示设置为返回值
      RLENGTH特殊变量设置为math匹配的字符串的长度.
split(string,array, [regex]) # 使用regex对string进行分割,并把分割后的数据放在数组array中. 如果没有给出regex则使用当前分隔符(FS特殊变量)来进行
tolower(string) # 字符串转换为小写
toupper(string) # 字符串转换为答谢
sprintf(Format, expr,expr,...)  # 根据Format类格式化输出字符串
strtonum(str)   # str字符转换为数值


# 时间函数
mktime(YYYY MM DD HH MM SS[DST])    # 生成时间格式
awk 'BEGIN{
    print "Number of seconds since epoch:" mktime("2014 12 14 30 20 10")
}'
## 输出 Number of seconds since epoch: 1418604610

strftime(format, [timestamp])   # 格式化时间输出. 将时间戳转换为字符串

awk 'BEGIN{
    print strftime("Time=%m/%d/%Y %H:%M:%S", systime())
}'
# 输出: Time=12/14/2021 22:08:02

systime()       # 得到时间戳. 从 1970-1-1 开始到当前的秒数

# 位操作函数
and  # 位与操作
awk 'BEGIN{
    num1=10
    num2=6
    print "(%d AND %d) = %d\n",num1,num2,and(num1,num2)
}'
输出: (10 AND 6) = 2

compl # 按位求补
awk 'BEGIN{
    num1=10
    print "compl(%d) = %d\n",num1,compl(num1)
}'
输出: compl(10) = 9007199254740981

lshift  # 左移位操作
awk 'BEGIN{
    num1=10
    print "lshift(%d) by 1 = %d\n",num1,lshift(num1,1)
}'
输出: lshift(10) by 1 = 20

rshift  # 右移位操作
awk 'BEGIN{
    num1=10
    print "rshift(%d) by 1 = %d\n",num1,rshift(num1,1)
}'
输出: lshift(10) by 1 = 5

or  # 按位或操作
awk 'BEGIN{
    num1=10
    num2=6
    print "(%d OR %d) = %d\n",num1,num2,or(num1,num2)
}'
输出: (10 OR 6) = 14

xor  # 按位异或操作
awk 'BEGIN{
    num1=10
    num2=6
    print "(%d XOR %d) = %d\n",num1,num2,xor(num1,num2)
}'
输出: (10 XOR 6) = 12

# 其他函数
close(expr) # 关闭管道文件
awk 'BEGIN{
    cmd = "tr [a-z] [A-Z]"          #在awk中创建一个双向的通信通道
    print "hello world" |& cmd      # 为tr命令提供输入, &| 表示双向通道
    close(cmd,"to")                 # 关闭to进程
    cmd |& getline out              # 使用getline函数将输出存储到out变量中
    print out                       # 打印out变量
    close(cmd)                      # 关闭cmd
}'
delete  # 用于从数组中删除元素
awk 'BEGIN{
    arr[0] = "one"
    arr[1] = "two"

    delete arr[0]
}'

exit #  # 终止脚本执行
awk 'BEGIN{
    print "hello"
    exit 10
    print "world"
}'


flush # 刷新打开文件或管道的缓冲区
getline  # 读取下一行
awk 'BEGIN{
    getline; print $0
}'

next # 停止处理当前记录,并且进入下一条记录的处理过程
awk 'BEGIN{
    if($0 ~ /sys/) next; print $0
}'

nextfile # 停止处理当前文件,从下一个文件第一个记录开始处理
awk '{
    # 当读取file1.txt中的内容有一条记录为 "text" 时,开始处理file2.txt 文件
    if($0 ~ /text/) nextfile; print $0
}' file1.txt  file2.txt

return # 从用于自定义的函数中返回结果. 如果没有指定返回值,那么返回的值是未定义的
system # 指定特定的命令然后返回其退出的状态码. 返回0表示成功, 非0表示执行失败.
awk 'BEGIN{
    ret=system("date"); print "return value:" ret
}'



