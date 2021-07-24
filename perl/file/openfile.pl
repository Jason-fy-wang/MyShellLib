#!/usr/bin/perl

=pod
perl使用一种叫做 `句柄文件`类型的变量来操作文件.
从文件读取 或者 写入数据需要使用文件句柄
文件句柄 是一个 I/O 连接的名称
perl 提供了三种文件句柄: STDIN, STDOUT,STDERR,分别代表标标准输入 标准输出  错误输出

open FILEHANDLE  EXPR
open FILEHANDLE
< 或 r: 只读方式打开文件, 将文件指针指向文件夹 
> 或 w:  写入方式打开,将文件指针指向文件头并将文件大小截为0,如果文件不存在则尝试创建
>> 或 a: 追加写入方式打开,将文件指针指向文件末尾,如果文件不存在则尝试创建
+< 或 r+: 读写方式打开,将文件指针指向文件头
+> 或 w+: 读写方式打开, 将文件指针指向文件头并将文件大小截为0,如果文件不存在则创建
+>> 或 a+: 读写方式发开,将文件指针指向文件末尾,如果文件不存在则创建

open(DATA, ">file.txt") or die "file.txt 文件不能打开, $!"
open(DATA, "<file.txt") or die "file.txt 文件不能打开, $!"
open(DATA, "+>file.txt") or die "file.txt 文件不能打开, $!"
open(DATA, "+<file.txt") or die "file.txt 文件不能打开, $!"
open(DATA, ">>file.txt") or die "file.txt 文件不能打开, $!"
open(DATA, "+>>file.txt") or die "file.txt 文件不能打开, $!"


syspoen FILEHANDLE, filename, MODE, perms
sysopen FILEHANDLE, filename, MODE

FILEHANDLE:文件句柄,用于存放时一个文件唯一标识符
EXPR: 文件名 及 文件访问类型组成的表达式
MODE: 文件访问类型
PERMS: 访问权限位, 例如: 0x666
filename: 文件名

可能MODE值:
O_RDWR: 读写方式打开,将文件指针指向文件头
O_RDONLY: 只读方式打开, 将文件指针指向文件头
O_WRONLY: 写入方式打开,将文件指针指向文件头并将文件大小截为0, 如果文件不存在则尝试创建
O_CREAT: 创建文件
O_APPEND:追加文件 
O_TRUNC: 将文件大小截为0
O_EXCL: 如果使用O_CREAT时文件存在,就返回错误信息, 它可以测试文件是否存在
O_NONBLOCK: 非阻塞I/O时,操作要么成功,要么立即返回错误, 不被阻塞
=cut
sub OpenFile{
    my $filename = $_[0];
    print($filename);
    open(DATA, "<$filename") or die "$filename can't be open, $!";
    while(<DATA>){
        print $_;
    }
    close (DATA) || die "close $filename error, $!";
}


sub SysOpenFile{
    my $file = $_[0];
    sysopen(DATA, $file, O_RDWR);
    while(<DATA>){
        print $_;
    }

    close(DATA) || die "close $file error, $!";
}

# OpenFile("testFile");
SysOpenFile('testFile');
