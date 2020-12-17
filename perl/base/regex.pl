#!/usr/bin/perl -w

=pod
匹配: m// (简写为//, 去除m)
替换: s/// 
        s/pattern/replicemnt/
    标志:
    i: 大小写不敏感
    m: 
    o: 表达式只执行一次
    s: 默认的"."将代表任意字符,包括换行符
    x: 表达式中的空白符将被忽略
    g: 替换所有匹配的字符串
    e: 替换字符串作为表达式

转换: tr///
        tr/pattern/transive/
    标志:
    c: 转换所有未指定字符
    d: 删除所有指定字符
    s: 把多个相同的输出字符缩成一个


=~: 匹配
!~: 不匹配
=cut

$bar="I am runnoob site";
if($bar =~ /run/){
    print("匹配 run \n")
}else{
    print("不匹配 run \n")
}



