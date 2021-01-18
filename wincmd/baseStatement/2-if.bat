goto syntax
syn:
if [not] ERRORLEVEL number command
if [not] string1==string2  command
if [not] exist fileName command

not: 将结果取反
ERRORLEVEL number: 最后运行的程序返回一个等于或大于指定数组的退出吗,则为true
string1==string2: 字符串相等 则为true
exist filename: 文件存在
command:    要执行的命令
:syntax


goto syn1
if-else if-else

 EQU |等于
 NEQ |不等于
 LSS |低于
 LEQ |小于或等于
 GTR |大于
 GEQ |大于或等于
:syn1

@echo off
set /P score="input score:"
if %score% LSS 60 (
    echo try harder~
) else if %score% LSS 70 (
    echo well
) else if %score% LSS 80 (
    echo not bad
) else if %score% LSS 90 (
    echo 优秀~
)else (
    echo good~
)