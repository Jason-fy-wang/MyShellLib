use 5.010;
# grep demo
# 过滤奇数
foreach (1..10){
    push @result, $_ if $_ % 2;
}
say "result: @result";


say "another style";
say;
say;
# {$_ % 2}此相当于是一个匿名函数
@res = grep {$_ % 2} 1..10;
say "res = @res";

say;
# 中间的匿名函数可以简写
@ress = grep $_%2, 1..10;
say "ress = @ress";
