use 5.010;

@arr = qw/ fred we have three learn /;

foreach(@arr) {
    # ~~ 智能匹配
    if ($_ ~~ /fred/){
        say "i have $_";
    }
    # =~ 正则匹配
    if ($_ =~ /three/){
        say "I have key world: $_"
    }
}
# given- when 语法的使用
foreach(@arr){
    given ($_){
    when($_ ~~ /three/){
        say "I have key word: $_";
    }
    when ($_ =~ /fred/){
        say "name: $_";
    }
    when ($_ ~~ /learn/){
        say "do you want: $_";
    }
    }
}
say "another style..";
say();
say ;
foreach(@arr){
    # 使用内置变量$_, 所以这里的 given 语句就可以省略了
    # 而且因为使用了 $_, 所以连智能匹配的符号 ~~ 都可以省略了
    when(/three/) {say "I have number: $_";}
    when(/fred/) {say "got name: $_";}
    when(/learn/){say "I want to $_ anything.";}
    default {say "got nothing";}
}





