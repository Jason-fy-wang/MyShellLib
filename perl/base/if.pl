#!/usr/bin/perl -w

# 单行注释
=pod
多行注释
=cut
$a=10;

if ($a < 20){
    print ("a less than 20\n");
}elsif($a > 10){
    print("a greater than 10\n");
} else{
    print("a=$a\n");
}

unless ($a == 30){  # 条件为false时执行
    print("a 的值不为30");
}elsif( $a == 30){
    print "a的值为30\n";
}else{
    print("a=$a\n");
}

# 使用switch模块
use Switch;   # 此模块需要安装
$var=10;
@arr=(1,2,3);
%hash=('key1'=>10,'key2'=>20);

switch($var){
    case 10 {print("数字10\n")}
    case "a" {print("字符串 a\n")}
    case [1..10,42] {print("在列表中\n")}
    case (\@arr) {print("在数组中\n")}
    case (]%hash) {print("在hash结构中\n")}
    else {print ("没有匹配的条件\n")}
}

