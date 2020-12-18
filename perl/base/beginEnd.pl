#!/usr/bin/perl -w

=pod
BEGIN{}  在程序中的其他语句执行前执行
END{}    在其他语句执行后执行
=cut

print("this is test for begin end\n");

BEGIN{
 print("this is begin block\n");
}

END{
    print("this is end block\n");
}
