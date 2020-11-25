#!/bin/bash

<<!
# 1. 使用符号替换
# 此使用 {} 来替换查找到的文件
[root@localhost sh]# find . -name tt.sh -type f | xargs -I{} ls -lh {}
-rw-r--r--. 1 root root 76 Nov 25 11:34 ./tt.sh

# 使用 [] 替换查找
[root@localhost sh]# find . -name tt.sh -type f | xargs -I[] ls -lh []
-rw-r--r--. 1 root root 76 Nov 25 11:34 ./tt.sh

# 使用# 号替换 
[root@localhost sh]# find . -name tt.sh -type f | xargs -I# ls -lh #
total 4.0K
-rw-r--r--. 1 root root 76 Nov 25 11:34 tt.sh

# 2. 常用的参数
-0(数字0) : 表示使用 NULL 作为结束, 对于那些名字有空格等特殊参数的
-n: 指定接收几个参数
-d: 指定分隔符
-a: 可以使用-a读取文件作为所有参数
-I: 进行替换
!

# -0 参数的处理
<<!
# 特殊的文件
[root@localhost sh]# touch 'hello world.txt'
# 删除时 出问题
[root@localhost sh]# find . -type f | xargs rm 
rm: cannot remove ‘./hello’: No such file or directory
rm: cannot remove ‘world.txt’: No such file or directory
## 解决方式
[root@cn00103147 sh]# find . -type f -print0 | xargs -0
./hello world.txt
[root@cn00103147 sh]# find . -type f -print0 | xargs -0 rm 
[root@cn00103147 sh]# ll
total 0

-print0  在末尾添加一个null
-0 读取到null认为是一个参数
!

## 读取参数个数
<<!
[root@cn00103147 sh]# echo "1 2 3 4 5" | xargs -n 1
1
2
3
4
5
[root@cn00103147 sh]# echo "1 2 3 4 5" | xargs -n 2
1 2
3 4
5
[root@cn00103147 sh]# echo "1 2 3 4 5" | xargs -n 3
1 2 3
4 5
[root@cn00103147 sh]# echo "1 2 3 4 5" | xargs -n 5
1 2 3 4 5
!
# 指定分隔符
<<!
[root@cn00103147 sh]# echo "1:2:3:4,5" | xargs -n 1 -d":"
1
2
3
4,5
!