#!/usr/bin/perl -w

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
