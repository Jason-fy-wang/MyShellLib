
use 5.010;
# glob 获取当前文件夹中的符合规则的文件
 @files = glob "*.pl" ;

 foreach (@files) {
     say "file : $_";
 }

 # 使用map进行一些操作,如过滤
 # 中间仍然是 匿名函数
 my @resfile = map {/(arg|if|loop)\.pl$/}  @files;
say "map files: @resfile";

my @resfile = map /(.*\.pl)$/,  @files;
say "map2 files: @resfile";

# get file size:
my @filesize = map {-s} @files;
print"file size: @filesize";
