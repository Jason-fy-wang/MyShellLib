#!/usr/bin/perl -w

# hash是一个无序的key/value集合,可以使用键作为下标获取值
#hash定义 字符 % 开头
%h=('a'=>1, 'b'=>2);
print("h{a}=$h{'a'}\n");
print("h{b}=$h{'b'}\n");
# 第一个元素是key,第二个元素是value
%h2=('to','todou','al','alibaba');
$data{'to'} = 'todou';
$data{'al'} = 'alibaba';

# 读取多个hash值
@arr=@data{'to','ali'};
print("arr=@arr\n");

# 获取所有的key值
=pod
keys %hash
=cut
@kks=keys %data;
print("keys=@kks\n");

# 获取所有的value值
=pod
values %hash
=cut
@valus=values %data;
print("values=@valus\n");

# 检测元素是否存在
=pod
exists(%data{'key'})
=cut
$ext=exists($data{'all'});
print("exists=$ext\n")

# 迭代hash
%tts=('go'=>'goole','bi'=>'baidu');
foreach $key (keys %tts){
    print("key=$key, values=$tts{$key}\n")
}

while(($k,$val) = each(%tts)){
    print("key=$k,values=$val");
}


