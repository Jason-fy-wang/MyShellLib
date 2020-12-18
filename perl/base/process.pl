#!/usr/bin/perl -w

# perl创建子进程可以使用fork  exec
# fork 创建一个新进程,在父进程中返回子进程的PID,在子进程中返回0,如果发生错误(如:内存不足)返回undef,并将$!设置为对应的错误信息
# exec 执行完参数中的命令 就会退出

=pod
子进程退出时,向父进程发送一个CHILD的信号后,就会变成僵死的进程,需要父进程使用wait或者waitpid来终止.
$SIG{CHILD}=IGNORE;  获取子进程发送的 CHIILD信号. 
# 由此可见: SIG保存了信号处理方式

kill('signal', (Process List));  # 向一组进程发送信号
=cut

if(! defined($pid=fork())){
    # 发生错误
    die "can't create sub process:$!";
}elsif($pid == 0){
    #子进程
    print("sub process: $$\n");
    exec("date") || die("can't print date info: $!");
}else{
    # 父进程
    # 获取进程id:$$
    # 但是 $PROCESS_ID 此使用失败
    print("parent process ..$$\n");
    $ret=waitpid($pid,0);
    print("complete process Id: $ret\n");
}

