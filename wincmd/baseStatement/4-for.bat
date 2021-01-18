goto sync
# cmd窗口中
for %i in (command1) do command2

# 批文件中
for %%i  in (command1) do command2

command1中的每个元素之间，用空格键、跳格键、逗号、分号或等号分隔
:sync

goto fun1
    @echo off
    for %%i in (ABC,abc) do echo " %%i "
    pause

:fun1