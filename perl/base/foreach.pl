
@arr1 = qw /1 2 3 4 5 6 /;
foreach $i (@arr1){
    print $i;
}
print "\n";


foreach $i (1..19){
    print $i;
}

print "\n";

# 使用默认变量遍历数组
foreach (a..z){
    print $_;
}
print "\n";

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
print "push ............................\n";
# 添加数据到数组中
@arr11 = (1..5);
push(@arr11, 100);
push @arr11,200;
print "arr11 = @arr11";
print "\n";

print "pop ............................\n";
# 删除数组中的值
@arr2 = (1..9);
$del = pop(@arr2);
print "del res = $del" . "\n";
print "@arr2";
print "\n";

# 不保存数据，直接删除
pop @arr2 ;
pop @arr2;
print "arr2 = @arr2";
print "\n";

@arr3 = qw# 1 2 3 4 5 #;
$m = shift(@arr3);
$i = shift(@arr3);
print "m = $m, i=$i,arr3 = @arr3";
print "\n";

unshift(@arr3, 100);
unshift(@arr3, 200);
unshift(@arr3, 300);
print "arr3 = @arr3";
print "\n";

# 翻转
@arr4 = (1..10);
print "arr4 = @arr4";
print "\n";
@arr5 = reverse(@arr4);
print "arr5 = @arr5";
print "\n";

print "sorting....................\n";
# 数组排序
=pod
sort [SUBROUTINE] LIST
SUBROUTINE: 指定规则
LIST: 列表或数组
=cut

@arr6 = qw/one aw te/;
@sorted = sort(@arr6);
print "sort = @sorted";
print "\n";

@reversesort = reverse sort(@arr6);
print "reverse sort = @reversesort";
print "\n";

@numbers = (20,1,9,2,10,11);
print "numbers = @numbers";
print "\n";
@sortnum = sort(@numbers);
print "sort num = @sortnum";
print "\n";

@realsort = sort {$a<=>$b} @numbers;
print "reals sort = @realsort\n";

###  scalar
@arr7 = (1..9);
print "how many numbers do you have?\n";
print "i hava ", scalar @arr7 ," numbers\n";

# read from input
## 输入一行
print "please input you name: \n";
$oneline = <STDIN>;
print "name = $oneline \n";

## 输入对行数据
print "please input you family name:\n";
@lines = <STDIN>;
print "lines = @lines \n";