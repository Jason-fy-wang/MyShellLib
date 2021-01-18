## 
错误级别“errorlevel”是MS-DOS的内置环境变量，在上面已经介绍过，主要用于保存上一条命令语句是否执行成功，成功则返回0，失败或错误则返回相对应的错误级别码
%errorlevel%

%CD% #代表当前目录的字符串
%DATE% #当前日期
%TIME% #当前时间
%RANDOM% #随机整数，介于0~32767
%ERRORLEVEL% #当前 ERRORLEVEL 值
%CMDEXTVERSION% #当前命令处理器扩展名版本号
%CMDCMDLINE% #调用命令处理器的原始命令行

