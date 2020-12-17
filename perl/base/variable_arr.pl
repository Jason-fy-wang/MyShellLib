#!/usr/bin/perl -w

# 数组变量以字符 @ 开头,索引从0开始
@arr=(1,2,3);
print("arr[0]=$arr[0]\n");
print("arr[1]=$arr[1]\n");

# 数组定义第二种方式,qw运算符,数组元素以空格分隔
@arr2=qw/one two three four/;
print("arr2=@arr2\n");
# 序列输出  起始值+..+结束值
@arr_seq=(1..10);
@arr_abz=(a..z);
print("arr_seq=@arr_seq\n");
print("arr_abz=@arr_abz\n");


# 复制数组
@copy=@arr;
print("arr copy=@copy\n");
# 获取数组长度
$size=@arr;
print("arr size=$size\n");

# 获取数组的最大索引
$maxIndex=$#arr;

=pod
数组函数:
push @array, list
将列表的值放到数组的末尾

pop @array
删除数组的最后一个值

shift @array
弹出数组第一个值,并返回. 数组的索引值也一次减1

unshift @array,list
将列表放在数组前面,并返回新数组的元素个数
=cut


# 数组切割
@sites=(1,2,3,4,5);
@sites2=@sites[1,2,4]; # 此时 sites2=(2,3,5)
@sites3=@sites[1..3];  # sites3=(2,3,4)

# 替换元素
=pod
splice @array,offset [, length, [, list]]
@array: 要替换的数组
offset: 起始位置
length: 替换的元素个数
list: 替换的元素列表

@st1=(1,2,3,4,5);
splice(@st1,1,2,21..22);
@st1=(1,21,22,4,5);
=cut

# 将字符串转换为数组
=pod
 split [pattern [,expr[, limit]]]
 pattern: 分隔符,默认为空格
 expr: 指定字符串数
 limit: 如果指定该参数, 则返回数组的元素个数

 $var_str="www-run-com";
 @str=split("-", $var_str);

 # @str=(www,run,com);
=cut

# 数组转换为字符串
=pod
join expr,list
expr: 连接符
list: 列表或数组

@st2=(www,run,com);
$str = join('-',@st2);
#str值为 www-run-com
=cut

# 数组排序
=pod
sort [SUBROUTINE] LIST
SUBROUTINE: 指定规则
LIST: 列表或数组
=cut
