
# 从命令行读取传递进来的文件内容
# example: while_read.pl file.txt
## example 1:
=pod
while(<>){
    next if /^#/;
    my $line = $_;
    @arr = split /:/, $line;
    print "name: @arr[0], money: @arr[$#arr-1] \n";
}
=cut
# example: 对上面的程序进行简化
=pod
while(<>){
    next if /^#/;
    my ($name,$age,$card,$money) = split /:/;
    print "name: $name -->  money: $money \n";
}
=cut

#example:再次对上面的程序进行简化
=pod
while(<>){
    next if /^#/;
    my ($name, undef,undef,$money) = split /:/;
    print"name = $name --> $money \n";
}

=cut
# example: 使用切片 再次简化
while (<>){
    next if /^#/;
    my ($name,$money) = (split(/:/))[0,3];
    print("name: $name --> $money \n");
}






