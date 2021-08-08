
# 打印文件的信息
my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdef,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat("file.txt");

print "dev = $dev \n
       ino = $ino \n
       mode = $mode \n
       nlink = $nlink\n
       uid = $uid \n
       gid = $gid \n
       redf = $rdef \n
       size = $size \n
       atime = $atime \n
       mtime = $mtime \n
       ctime = $ctime \n
       blksize = $blksize \n
       blocks = $blocks \n"