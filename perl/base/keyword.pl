
=pod
undef : 一个变量没有初始化 就是undef,当数据类型是数值型时,undef表示0; 当数据类型是string类型是,表示一个没有长度的空字符串
example:
    a = undef;
.(点) :  字符串连接操作符
x : 字符串重复操作;如: a x 5 结果为: aaaaa

chomp: 用于去除一个变量左右的空格

defined: 用于检测一个数值有没有被定义
exampl:
    if (defined($a)){
        print $a;
    }else{
        print "a 没有被定义";
    }
=cut

# 表示从标准输入读取数据
print "Please input your name:\n";
$a = <STDIN>;
chomp($a);  # 此函数 chomp返回值是 去除的空格的数量
print $a;