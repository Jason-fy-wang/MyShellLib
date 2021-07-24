=pod
变量类型
1. 全局标量特殊变量
2. 全局数组特殊变量
3. 全局哈希特殊变量
4. 全局特殊文件句柄
5. 全局特殊变量
6. 正则表达式特殊变量
7. 文件句柄变量

全局标量特殊变量
$_      默认输入和模式匹配内容
$ARG

$.      前一次读的文件句柄的当前行号 
$NR

$/      输入记录分隔符,默认是换行符, 如果undef这个变量,将读到文件结尾
$RS 

$,      输出域分隔符
$OFS    

$\      输出记录分隔符
$ORS

$"      改变了同$,类似,但应用于向双引号括起来的字符串(或类似的内插字符串)中内插数组和切片的场合.默认是一个空格
$LIST_SEPARATOR

$;      在仿真多维数组时使用的分隔符,默认是"\034"
$SUBSCRIPT_SEPARATOR

$^L     发送到输出通道的走纸换行符, 默认为 "\f"
$FORMAT_FORMFEED

$:      The current set of characters after which a string may be broken to fill continuation fields(starting with ^)in a format. default is "\n"
$FORMAT_LINE_BREAK_CHARACTERS

$^A     打印前用于保存格式化数据的变量
$ACCUMULATOR

$#      打印数组时默认的数字输出格式 (已废弃)
$OFMT

$?      返回上一个外部命令的状态时
$CHILD_ERROR

$!      这个变量的数字是errno的值, 字符串值是对应的系统错误字符串
$OS_ERROR | $ERRNO

$@      命令eval的错误信息,如果为空,则表示上一次eval命令执行成功
$EVAL_ERROR

$$      运行当前perl脚本程序的进程号
$PROCESS_ID | $PID

$<      当前进程的实际用户
$REAL_USER_ID | $UID

$>      当前进程的有效用户
$EFFECTIVE_USER_ID | $EUID

$(      当前进程的实际用户组
$REAL_GROUP_ID | $GID

$)      当前进程的有效用户组
$EFFECTIVE_GROUP_ID | $EGID

$0      当前正在执行脚本的文件名
$PROGRAM_NAME

$[      数组的数组第一个元素的下标,默认是0


$]      perl的版本号
$PERL_VERSION

$^D     调试标志额值
$DEBUGGING

$^E     在非unix环境中的操作系统扩展错误信息
$EXTENDED_OS_ERROR

$^F     最大的文件句柄数
$SYSTEM_FD_MAX

$^H     由编译器激活的语法检查状态

$^I     内置控制编译器的值
$INPLACE_EDIT

$^M     备用内存的大小

$^O     操作系统名
$OSNAME

$^P     指定当前调试值的内部变量
$PERLDB

$^T     从新世纪开始算起,脚本以秒计算的开始运行时间
$BASETIME

$^X     perl二进制可执行代码的名字
$EXECUTABLE_NAME

$ARGV   默认的文件句柄中读取时的当前文件名

全局数组特殊变量
@ARGV   传给脚本的命令行参数列表
@INC    在导入模块时需要搜索的目录列表
@F      命令行的数组输入

全局哈希特殊变量
%INC    散列表%INC包含所有用do或require语句包含的文件,关键字是文件名,值是这个文件的路径
%ENV    包含当前环境变量
%SIG    信号列表及其处理方式

全局特殊文件句柄
ARGV     遍历数组遍变量@ARGV中的所有文件名的特殊文件句柄
STDERR   标准错误输出句柄
STDIN    标准输入句柄
STDOUT   标准输出句柄
DATA      特殊文件句柄引用了在文件中__END__标志后的任何内容包含脚本内容. 或者引用一个包含文件中__DATA__标志后的所有内容, 只要你在同一个包中读取所有数据, __DATA__就存在
_(下划线)  特殊的文件句柄用于缓存文件信息(fstat, stat,lstat)

全局特殊变量
__END__   脚本的逻辑结束,忽略后面的文本
__FILE__   当前文件名
__LINE__    当前行号
__PACKAGE__ 当前包名,默认包名是main

正则表达式特殊变量
$n  包含上次模式匹配的第n个子串

$&  前一次成功模式匹配的字符串
$MATCH  

$`  前次匹配成功的子串之前的内容
$PREMATCH

$'  前次匹配成功的子串之后的内容
$POSTMATCH

$+  与上个正则表达式搜索格式匹配的最后一个括号,如: /Version: (.*)|Revision: (.*)/ && ($rev = $+)
$LAST_PAREM_MATCH

文件句柄特殊变量
$|      如果设置为0,在每次调用函数write或print后,自动调用函数fflush, 将所写内容写回文件
$OUTPUT_AUTOFLUSH

$%      当前输出页号
$FORMAT_PAGE_NUMBER 

$=      当前每页长度, 默认是60
$FORMAT_LINES_PER_PAGE

$-      当前剩余的行数
$FORMAT_LINES_LEFT

$~      当前报表输出格式的名称, 默认值是文件句柄名
$FORMAT_NAME

$^      当前报表表头格式的名称. 默认值是带后缀 "_TOP" 的文件句柄名
$FORMAT_TOP_NAME
=cut
