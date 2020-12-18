#!/usr/bin/perl -w

=pod
next: 停止执行从next下一句到结束标识符之间的语句,转去执行continue语句,然后再返回到循环体起始处执行下一次循环
last: 退出循环语句块, 从而结束循环
continue: 跳过本次循环执行下次循环
redo: redo语句执行跳转到循环体的第一行开始重复本次循环,redo之后的语句不再执行
goto: gogo LABEL, goto expr, goto &name;

=cut
# while
$a=10;
while($a < 20){
    print("a=$a\n");
    $a=$a+1;
}

until($a > 30){
    print("a=$a\n");
    $a=$a+1;
}

for($b=0; $b<10;$b=$b+1){
    print("b=$b\n");
}

@list=(1,2..10);
foreach $itm (@list){
    print("itm=$itm\n");
}

$c=10;
do{
    print("c=$c\n");
    $c=$c+1;
}while($c <15);
