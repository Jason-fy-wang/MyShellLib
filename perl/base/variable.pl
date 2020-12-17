#!/usr/bin/perl -w

# 前面加一个 $ 表示的是标量,这种数据类型的变量可以是数字,字符串,浮点数,不做严格的区分.
# 在使用时,在变量的前面加一个$,表示的就是标量
$a = "abcdefg";

#here 文档
$hdoc = <<"EOF";
This is here doc,you can input varchar and varable,
for example: a=$a;
EOF

# print 加括号 不加 括号都可以
print "$hdoc";
print("$hdoc");

# 标量运算
$str="hello"."world";  # 字符串拼接
$num=5+10;  # 两数相加
$mul=4*5;   # 两数相乘
$mix=$str.$num;  # 连接字符串和数字
print("str=$str\n");
print("num=$num\n");
print("mul=$mul\n");
print("mix=$mix\n");

# 特殊字符
# 文件名: __FILE__  行号: __LINE__ 包名: __PACKAGE__
print("file name=".__FILE__);
print("line num=".__LINE__);
print("package=".__PACKAGE__);