rem
    命令rem用作注释,rem开头的行会被忽略不做处理
pause
    pause命令停止批处理文件处理并要求用户按键,用户按键后会继续执行处理过程

echo
    该命令将它后面的文本显示到DOS控制台上面.

echo off
   echo off 防止批处理中的命令被显示,只显示执行结果.但是echo off命令仍会显示,要进制echo off命令可以使用@echo off 

@echo off
    禁止命令本身以及其他命令的输出
set
    该命令用于设置用户定义的或者环境变量. 设置的环境变量的值临时存放在内存中,在处理完成后被抛弃

label:
    使用冒号来处理一个标签，你可以将标签出传递给goto命令，让处理过程跳到给标签处。
    如:    :end
goto:
    goto命令强制批处理文件跳到标签定义的行.
if
    if用于测试,有三种使用方式:
        1.To test the value of a variable. 测试一个变量的值
        2.To test the  existence of a file. 测试文件的存在性
        3.To test the  error value.   测试错误值
    Example:
        ## 测试一个变量的值
        if  variable==value  nextCommand
        
        ## 定义一个变量,测试其值
        set myVar=3
        if %myVar%==3  echo Correct
        
        # 测试一个文件是否存在
        # 如果c:\tmp目录下存在myFile.txt文件,就跳转到start标签
        if  exist c:\tmp\myFile.txt   goto start
            

not
    not用于对一个表达式取反
    # 在变量myVar的值不为3时,打印出Correct
    set myVar=3
    if not %myVar%==3  echo Correct
    pause
    
    # 如下命令, c:\tmp目录下不存在myFile.txt文件的时候跳到end标签
    if not exist c:\tmp\myFile.txt  goto end    


exist:
    exist 跟if语句连接用于测试一个文件是否存在


接受参数:
    可以给批处理文件传递参数,可以使用 %1 引用第一个参数, %2引用第二个参数,依次类推

shift:
    命令shift向后移动参数,意味着 %2指向%1,  %3指向%2

call:
    call用于调用另外一个命令

setLocal:
    setLocal命令用来指明对于环境变量的改变全是本地的.环境变量的值会在执行完文件或碰到endLocal命令后恢复

start
    要打开一个新的窗口,可以使用start命令,可以传递个参数作为窗口的标题

For more information on a specific command, type HELP command-name
ASSOC          Displays or modifies file extension associations.
                    显示或更改文件扩展名连接
ATTRIB         Displays or changes file attributes.
                    显示或更改文件属性
BREAK          Sets or clears extended CTRL+C checking.
                    设置或清楚扩展名，ctrl+c检查
BCDEDIT       Sets properties in boot database to control boot loading
                    
CACLS          Displays or modifies access control lists (ACLs) of
                    显示或修改文件的访问控制列表
CALL            Calls one batch program from another.
                    从一个批处理调用另一个批处理
CD              Displays the name of or changes the current director
                    显示目录名或更改目录
CHCP          Displays or sets the active code page number.
                    显示或设置活动代码页数字
CHDIR         Displays the name of or changes the current director
                    显示当前的目录名或更改
CHKDSK       Checks a disk and displays a status report.
                    检查磁盘并显示状态报告
CHKNTFS     Displays or modifies the checking of disk at boot time
                    显示或更改启动时磁盘检查
CLS             Clears the screen.
                    清屏
CMD            Starts a new instance of the Windows command interpr
                    打开另一个windows命令解释器窗口
COLOR         Sets the default console foreground and background color
                    设置默认终端的前景色后背景颜色
COMP          Compares the contents of two files or sets of files.
                    比较两个文件的内容
COMPACT     Displays or alters the compression of files on NTFS
                    显示或更改NTFS上的文件压缩
CONVERT     Converts FAT volumes to NTFS.  You cannot convert the  current drive.             
                       将FAT卷转换成NTFS，不能转换当前驱动器
COPY          Copies one or more files to another location.
                    复制一个或多个文件到另一个位置

copy  con  123.txt
                         这个命令就会把键盘输入的信息记录到123.txt文件
DATE          Displays or sets the date.
               显示或设置时间
DEL            Deletes one or more files.
               删除至少一个文件
DIR             Displays a list of files and subdirectories in a dir
                    显示一个目录中的文件或其子目录
DISKCOMP   Compares the contents of two floppy disks.
                    比较两个软盘上的内容
DISKCOPY    Copies the contents of one floppy disk to another.
               复制一个软盘的内容到另一个
DISKPART    Displays or configures Disk Partition properties.
                    显示或配置磁盘分区属性
DOSKEY       Edits command lines, recalls Windows commands, and creates macros.
                       编辑命令行，调用windows命令，并且创建宏
DRIVERQUERY    Displays current device driver status and properties
                         显示的当前设备驱动的状态和属性
ECHO           Displays messages, or turns command echoing on or off
                    显示信息，或把命令回显关闭
ENDLOCAL       Ends localization of environment changes in a batch
                    结束批处理文件中环境的更改的本地化
ERASE          Deletes one or more files.
                    删除一个或多个文件
EXIT           Quits the CMD.EXE program (command interpreter).
                  退出命令行
FC             Compares two files or sets of files, and displays the differences between them.
                    比较两个或多个文件，并显示他们之间的不同              
FIND           Searches for a text string in a file or files.
                    在至少一个文件中查找字符串
FINDSTR        Searches for strings in files.
                    在多个文件中查找字符串
FOR            Runs a specified command for each file in a set of files
                       为一套文件中每个文件运行一个指定的命令
FORMAT         Formats a disk for use with Windows.
                    格式化磁盘，以便windows使用
FSUTIL         Displays or configures the file system properties.
                    显示或配置文件的系统属性
FTYPE          Displays or modifies file types used in file extension associations.
                          显示或修改文件扩展名关联的文件类型
GOTO           Directs the Windows command interpreter to a labeled  a batch program.
                        将windows命令解释器指向一个批处理文件的标号处
GPRESULT       Displays Group Policy information for machine or use
                         为机器或用户显示自策略信息
GRAFTABL       Enables Windows to display an extended character set in graphics mode.
                            让windows用图形模式显示扩展字符集
HELP           Provides Help information for Windows commands.
                    提供帮助信息
ICACLS         Display, modify, backup, or restore ACLs for files and  directories.
                         显示，修改，备份或恢复文件或目录的ACL
IF             Performs conditional processing in batch programs.
                   执行批处理时条件性处理
LABEL          Creates, changes, or deletes the volume label of a disk
                    创建，改变。或删除一个磁盘的卷标
MD             Creates a directory.
                    创建一个目录
MKDIR          Creates a directory.
                    创建一个目录
MKLINK         Creates Symbolic Links and Hard Links
                    创建符号和硬件连接
MODE           Configures a system device.
                         配置系统设备
MORE           Displays output one screen at a time.
                    一次显示一个结果屏幕
MOVE           Moves one or more files from one directory to anothe  directory.
                    移动一个或多个文件从一个目录到另一目录             
OPENFILES      Displays files opened by remote users for a file share
                     显示被远程用户打开的分享文件
PATH           Displays or sets a search path for executable files.
                    显示或设置执行文件路径
PAUSE          Suspends processing of a batch file and displays a message
                    暂停批处理文件的处理并显示信息                    
POPD           Restores the previous value of the current directory by   PUSHD.
                    还原PUSHD保存的当前目录的上一个值
PRINT          Prints a text file.
                    打印文本文件
PROMPT         Changes the Windows command prompt.
                    更改windows命令提示符
PUSHD          Saves the current directory then changes it.
                    保存当前目录，然后对其进行更改
RD             Removes a directory.
                    删除目录
RECOVER        Recovers readable information from a bad or defectiv
                            从有问题的磁盘恢复可读信息
REM            Records comments (remarks) in batch files or CONFIG.sys
                    记录批处理文件或config.sys的注释
REN            Renames a file or files.
               重命名文件
RENAME         Renames a file or files.
                    重命名文件
REPLACE        Replaces files.
                    替换文件
RMDIR          Removes a directory.
                    删除目录
ROBOCOPY       Advanced utility to copy files and directory trees
                            拷贝文件和目录树
SET            Displays, sets, or removes Windows environment variable
                    显示，设置或移除windows环境变量
SETLOCAL       Begins localization of environment changes in a batch
                         开始批处理文件中环境更改的本地化
SC             Displays or configures services (background processes>
                    显示或配置服务(后台服务)
SCHTASKS       Schedules commands and programs to run on a computer
                     调度命令和程序在一个计算机上运行
SHIFT          Shifts the position of replaceable parameters in batch file
                    更换批文件中可替换参数的位置                    
SHUTDOWN       Allows proper local or remote shutdown of machine.
                         关机
SORT           Sorts input
                    对输入进行分类
START          Starts a separate window to run a specified program
                    启动另一个cmd来运行特定的命令
SUBST          Associates a path with a drive letter
                         将路径跟一个驱动器关联
SYSTEMINFO     Displays machine specific properties and configuration
                         显示机器特定属性个配置                              
TASKLIST       Displays all currently running tasks including service
                    显示所有当前运行的任务包括服务
TASKKILL       Kill or stop a running process or application.
                     杀死或停止一个运行这的程序或应用
TIME           Displays or sets the system time.
                    显示或设置系统时间
TITLE          Sets the window title for a CMD.EXE session.
                    设置cmd会话的标题
TREE           Graphically displays the directory structure of a drive or  path
                    以图形模式显示驱动器或路径的目录结构
TYPE           Displays the contents of a text file.
                         显示文本文件的内容
VER            Displays the Windows version.
                         显示windows的版本
VERIFY         Tells Windows whether to verify that your files are written  correctly to a disk.
                    告诉windows是验证下你写到磁盘的文件是否正确
VOL            Displays a disk volume label and serial number.
                    显示磁盘据表或序列号
XCOPY          Copies files and directory trees.
                    复制文件和目录树
WMIC           Displays WMI information inside interactive command shell
                    显示WMI信息在交互式命令行shell                    

WRITE   写字板
MSPAINT  画图板
mstsc    远程桌面连接
mmc  打开控制台
osk  打开屏幕键盘
utilman  辅助工具管理器
msbsync   同步命令
iexpress   木马捆绑工具
fsmgmt.msc  共享文件夹管理器
dcomcnfg        打开系统组件服务
clipbrd     剪贴板查看器
sysedit  系统配置编辑器
wscript   windows脚本宿主设置
appwiz.cpl          :添加删除程序
control userpasswords2     :用户账户设置
cleanmgr:垃圾整理
CMD: 命令提示符可以当作windows的一个附件，ping，convert这些不能在图形环境下使用的功能要借助它来完成


calc:计算器
chkdsk.exe：chkdsk磁盘检查

compmgmt.msc：计算机管理

conf：启动netmeeting
devmgmt.msc：设备管理器
diskmgmt.msc：磁盘管理实用程序
dfrg.msc  磁盘碎片整理程序
drwtsn32  系统医生
dvdplay   启动media player
dxdiag  ：directx  diagnotic  tool
gedit.msc  组策略编辑器
gpupdate/target: computer /force 强制刷新组策略

eventvwr.exe  事件查看器
explorer  资源管理器
logoff  注销
lusrmgr.msc  本机用户和组
msinfo32  系统信息

msconfig  系统配置实用程序
nerstart（servicename） 启动该服务
net stop （servicename） 停止该服务
notepad  打开记事本
nusmgr.cpl  打开用户账户控制面板
nslookup：IP地址侦测器
oobe/msoobe/a  检查xp是否激活
perfmon.msc  计算机性能监测程序
progman  程序管理器
regedit   注册表编辑器
regedit32  注册表编辑器
regsvr32/u *.dll  停止dll文件运行
route print  查看路由表
rononce -p  15秒关机
rsop.msc  组策略结果集
rundll32.exe  rundll32.exe%Systemroot%System32shimgvm.dll,ImageView_Fullscreen启动一个空白的             windows图片和传真查看器

secpol.msc   本地安全策略
service.msc   本地服务设置
sfc/scannow  启动系统文件检查器
sndrec32   录音机
taskmgr   任务管理器
tsshutdn    60秒倒计时关机
winchat     xp自带局域网聊天
winmsd   系统信息
winver  显示about windows窗口
wupdmgr   windows  update 

runas   以什么身份运行命令