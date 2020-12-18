#!/usr/bin/perl -w

# 脚本参数

=pod
$0 表示当前正在运行的Perl脚本名。有3种情况：
    如果执行方式为perl x.pl，则$0的值为x.pl而非perl命令本身
    如果执行方式为./x.pl，则$0的值为./x.pl
    如果执行的是perl -e或perl -E一行式perl程序，则$0的值为-e或-E

ARGV数组分三种情况收集：
    perl x.pl a b c方式运行时，脚本名x.pl之后的a b c才会被收集到ARGV数组
    ./x.pl a b c方式运行时，a b c才会被收集到ARGV数组
    perl -e 'xxxxx' a b c方式运行时，a b c才会被收集到ARGV数组

需要区分ARGV变量和ARGV数组：
    $ARGV表示命令行参数代表的文件列表中，当前被处理的文件名
    @ARGV表示命令行参数数组
    $ARGV[n]：表示命令行参数数组的元素
    ARGV：表示<>当前正在处理的文件句柄
读取2个文件(a.log,b.log)的内容：

#!/usr/bin/perl
    while(<>){
        print $_;
    }

如果想读取标准输入，只需使用"-"作为文件参数即可。
    echo -e "abcd\nefg" | ./test.plx a.log - b.log
上面将按先后顺序读取a.log，标准输入(管道左边命令的输出内容)，b.log。

=cut



# 获取到参数数量
$size=@ARGV;
print("arg size: $size\n");

while(<>){
    print("arg: $_\n");
}
=pod
echo a > a.log
echo b > b.log
perl tt.pl  a.log   b.log
## 输出:
arg: a
arg: b
=cut
for(@ARGV) {
    print("$_\n");
}

=pod
perl tt.pl 1 2 3 4 5
1
2
3
4
5
=cut


