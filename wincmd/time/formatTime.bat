@echo off
rem  print time with format YYYY-MM-DD HH:mm:ss
rem 15:26:52.52
echo %time%
rem 1
echo %time:~0,1%
rem 2021-01-18 15:26:52.53
echo %date:~0,4%-%date:~5,2%-%date:~8,2% %time%   
