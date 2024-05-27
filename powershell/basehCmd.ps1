# 打印环境变量
$env:path

# 打开notepad
notepad
&"notepad"   # 相当于使用 & 来执行字符串命令

# 获取所有命令
Get-Command

# 获取命令帮助信息
get-help  Command
help command 
help cmd -detail
help cmd -full
help cmd -examlpe

# 可以使用 powershell-ISE 来编写一些脚本
ctrl+j 会生成一个脚本模板

#  命令筛选; 查找Remove开头的命令
get-alias | where {$_.definition.startswith("Remove")} 

# 别名分组,并根据数量排序
get-alias | group-object definition | sort -descending Count

# 设置别名
set-alias -name pad -value notepad

# 删除别名
del alias:pad

# 导出别名
export-alias alias.ps

# 导入别名
import-alias -force demo.ps

# 定义变量
$name="zhansan"
$age=26
${"my name"}="wnagwu"   # 使用花括号括起来,可以定义一些特殊的变量

# 





