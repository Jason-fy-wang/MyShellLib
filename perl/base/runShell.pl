#!/usr/bin/perl -w

# 运行shell命令
# 方式一: 使用反引号直接执行命令
# 方式二: 使用system() 命令

@files=`ls -l`;

foreach $itm (@files){
    print("file info: $itm");
}

$data=system('date');
print("system date: $data");



