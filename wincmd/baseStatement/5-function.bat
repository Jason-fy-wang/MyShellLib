@echo off
goto sync
函数以 :func开始 以 goto:eof 结束.
:func 和 goto:eof 之间的内容为函数体

rem  goto:eof 相当于函数的} 结尾标记，返回到调用者位置
rem  exit /B 0  结束当前cmd，返回exitCode 0

:sync

:: 函数调用
echo =================================
echo ==========Func No paramter ======
echo =================================
call:myFuncNoParameter par1  par2  par3

echo =================================
echo ===========Func has paramter=====
echo =================================
call:myFuncHasParameter 123 abc

echo =================================
echo =======Func with return value====
echo =================================
set return=123
set returnPara=321
echo return: %return%
echo returnPara: %returnPara%
call:myFuncReturnValue  returnPara abc
echo return: %return%
echo returnPara: %returnPara%
:: 函数返回值
::  使用参数带回返回值
::  使用全局变量带回返回值

pause
EXIT /B 0
:myFuncNoParameter
    echo myFuncNoParameter enter
    echo myFuncNoParameter First para: %1
    echo myFuncNoParameter Second para: %2
    echo myFuncNoParameter Third para: %3
    echo myFuncNoParameter exit
goto :eof

:myFuncHasParameter
    echo myFuncHasParameter enter
    echo myFuncHasParameter First para: %1
    echo myFuncHasParameter Second para: %2
    echo myFuncHasParameter Third para: %3
    echo myFuncHasParameter exit
goto :eof

:myFuncReturnValue
    echo myFuncReturnValue enter
    echo myFuncReturnValue First para: %1
    echo myFuncReturnValue Second para: %2
    set "%~1=%2%"
    set return=%2
goto :eof


