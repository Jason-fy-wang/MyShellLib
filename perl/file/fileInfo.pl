#!/usr/bin/perl

=pod
文件类型判断
-A 文件上一次被访问的时间(单位:天)
-B 是否为二进制文件 
-C 文件的(inode)索引节点修改时间(单位: 天)
-M 文件上一次被修改时间 (单位:天)
-O 文件被真实的UID所有
-R 文件或目录可以被真实的UID/GID 读取
-S 是否为socket(套接字文件)
-T 是否为文本文件
-W 文件或目录 可以被真实的UID/GID 写入
-X 文件或目录可以被真实的UID/GID 执行
-b 为 block-special(特殊块)文件(如: 挂载磁盘)
-c 为character-special (特殊字符) 文件(如: I/O 设备)
-d 是否为目录
-e 文件或目录是否存在
-f 是否为普通文件
-g 文件或目录是否有 setgid 属性
-k 文件或目录是否设置了 sticky 位
-l 是否为符号链接
-o 文件被有效UID 所有
-p 文件是否是 命令管道
-r 文件是否可以被有效的 UID/GID 读取
-s 文件或目录存在且不为0(返回字节数)
-t 文件句柄为TTY (系统函数 isatty()的返回结果; 不能对文件名使用这个测试
-u 文件或目录具有 setuid 属性
-w 文件可以被有效的 UID/GID 写入
-x 文件是否可以被有效的UID/GID 执行
-z 文件存在,大小为0(目录恒为false), 即是否是空文件
=cut

sub testFile {
    my $file = $_[0];
    my (@description, $size);
    if (-e $file ){
        push @description, '是一个二进制文件' if (-B _);
        push @description, '是一个socket文件' if(-S _);
        push @description, '是一个文本文件' if (-T _);
        push @description,'是要给特殊块文件' if (-b _);
        push @description, '是一个特殊字符文件' if (-c _);
        push @description, '是一个目录' if (-d _);
        push @description, '文件是否可被执行' if (-x _);
        push @description, (($size = -s _))?"$size 字节":'empty';
        print("$file info: ", join (',', @description));
    }
}

testFile("testFile")

