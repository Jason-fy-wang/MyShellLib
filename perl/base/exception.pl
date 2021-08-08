use 5.010;
# perl 捕获异常的处理

@files = qw/ file1 file2 file3 fo;e4/;

# 使用eval 来捕获异常
foreach(@files){
    eval{
        open (FILEHANDLE, "<$_")  or die ("can't open file: $_, $!");
        say "opening: $_";
        # open FILEHANDLE, "< $_";
        say"open file $_";
        close FILEHANDLE;
    };
    # 如果有异常, 则直接把异常输出
    if ($@) {
        say"Error: $@";
    }
}
