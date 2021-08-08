#!/usr/bin/perl -w

# 数组变量以字符 @ 开头,索引从0开始
@arr=(1,2,3);
print "arr[0]=$arr[0]\n";
print "arr[1]=$arr[1]\n";

# 以 qw定义列表
@arr2 = qw / one two three /;
print "@arr2" . "\n";      # 这样打印自带空格

$, =","; # 重新设置 分隔符为 逗号
print @arr2;

print "\n";
@arr3 = qw { 123 btw qwe };
print "@arr3";
print "\n";

@arr4 = (1..5);
print @arr4 . "\n"; # 这样就变成了打印长度？
print @arr4;
print "\n";

# 复制数组
@copy = @arr4;
print @copy;
print "\n";
# 获取数组长度
$size = $#arr4;
print "size = " . $size . "\n";






# 数组切割
=pod
@sites=(1,2,3,4,5);
@sites2=@sites[1,2,4]; # 此时 sites2=(2,3,5)
@sites3=@sites[1..3];  # sites3=(2,3,4)
=cut
@sites = qw/1 2 3 4 5/;
print "sites = @sites";
print "\n";
@sites2 = @sites[1,2,4];
print "sites2 = @sites2";
print "\n";
@sites3 = @sites[1..2];
print "sites3 = @sites3";
print "\n";

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
@splice_arr = qw / q w e r t /;
splice @splice_arr,1,2,(1,2);
print "splice_arr = @splice_arr";
print "\n";

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

$string = "q,w,e,r,t";
@res = split(/,/, $string);
print "spl res = @res";
print "\n";

$str2 = "simen;stanly;jeeis-allen";
@res2 = split(";", $str2);
print "split res = @res2";
print"\n";

# 数组转换为字符串
=pod
join expr,list
expr: 连接符
list: 列表或数组

@st2=(www,run,com);
$str = join('-',@st2);
#str值为 www-run-com
=cut
@slarr = qw / run world evary day /;
$jonstr = join("--", @slarr);
print "jonstr = $jonstr";
print "\n";


# 分隔符
@arrtest = qw {1 2 3 4 one two three };
$" = ","; # 指定分隔符为 逗号
print "@arrtest";  # 打印列表




