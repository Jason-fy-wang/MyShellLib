#!/usr/bin/perl

=pod
读取文件
并进行一些判断
=cut

sub openFile {
    my $filename = $_[0];
    print($filename);
    open(DATA, "<$filename") || die "$filename cann't be open, $!";

    while (<DATA>) {
        # 跳过空行
        next if /^$/;
        # 跳过注释行
        next if /^#/;
        # 去除最后的换行符
        chomp; 
        $content = $_;
        print($content);
    }

    close(DATA);
}

sub openFile2 {
    my $filename = $_[0];
    print("open file $filename \n");
    open (DATA,"<$filename") || die "$filename cann't be open, $!";

    while(<DATA>){
        next if /^$/;
        next if /^#/;
        next if not /[,]/;
        chomp;
        $line = $_;
        #print("line=$line");
        # split(pattern, line, number)
        # pattern分隔符， line要分割的内容  number: 最多分成几份
        ($name, $age, $addr) = split (/,/, $line,3);
        print("name=$name, age=$age,addr=$addr \n");
    }
    close(DATA);
}


# call function
# openFile("testFile");
openFile2("testFile")
