#!/usr/bin/perl -w

=pod
引用的使用
perl的引用就是指针,perl引用是一个标量类型,可以指向变量,数组,hash甚至子程序,可以应用到程序的任何地方

在定义变量的时候,在变量名前加个 \, 就得到了这个变量的引用
$ref1=\$foo;        # 标量的引用
$ref2=\@array;      # 列表引用
$ref3=\%hash;       # hash的引用
$ref4=\&hander;     # 子过程的引用
$ref5=\*foo;        # GLOB 句柄引用

=cut

# 匿名数组引用
$aref=[1,'foo',13];
##  使用匿名数组引用创建多维数组
my $aaref = [
    [1,2,3,4],
    [1,2,3,4],
    [1,2,3,4],
];

# 匿名hash引用
$href={'key1'=>1,'key2'=>2};
# 匿名子程序引用
$codeRef=sub {print("function\n")};

=pod
使用ref 函数来查看引用的类型,引用类型:
SCALAR
ARRAY
HASH
CODE
GLOB
REF
=cut

# 解引用
$var1=10;
$r=\$var1;
print("r=$$r\n");

@var2=(1,2,3);
$r=\@var2;
print("r=@$r\n");

%var3=('key1'=>1);
$r=\%var3;
print("r=%$r\n");

# 函数引用 及 解引用
sub PrintHash{
    my (%hash)=@_;
    foreach $itm (%hash){
        print("元素:$itm\n");
    }
}
%hash=('name'=>'zs');
# 创建函数引用
$cref=\&PrintHash;
# 使用函数引用
&$cref(%hash);
