#!/usr/bin/perl -w

=pod
函数定义

sub subroutine{
    statements;
}
=cut

# function 1
sub sayHi{
    print("hello world\n");
}
# 函数调用
sayHi();

## 传递参数
=pod
子程序使用特殊数组 @_ 接收所有参数,
第一个参数为 $_[0], 第二个参数:$_[1];
=cut

sub Average{
    #$n = scalar(@_);
    $n = 0;
    $sum=0;
    foreach $itm (@_){
        $n += 1;
        $sum += $itm;
    }
    $avger=$sum/$n;
    print("参数个数为: $n\n");
    print("传递的参数为: @_\n");
    print("第一个参数值为: $_[0]\n");
    print("传入参数的平均值为: $avger\n");
}
Average(10,20,30,40);


## 传递list参数
sub PrintList{
    my @list=@_;
    print("list = @list\n");
}
$l1=10;
@la=(1,2,3,4);
PrintList($l1,@la);

# 传递hash参数
sub PrintHash{
    my (%hash) = @_;
    foreach my $kh (keys %hash){
        my $val=$hash{$kh};
        print("key=$kh, values=$val\n");
    }
}
%hash=('name'=>'zhangsan','age'=>10);
PrintHash(%hash);

# 子程序返回值
# >可以使用return 语句来返回函数值,如果没有return,则子程序最后一行将作为返回值
sub add{
    $_[0]+$_[1];
}
print(add(1,2));

sub add2{
    $sum=0;
    foreach my $val (@_){
        $sum+=$val;
    }
    return $sum;
}

print("sum value=".add2(10,20,30,40)."\n");




