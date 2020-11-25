#!/bin/bash

# 子shell的开启
# BASH_SUBSHELL 可以打印当前子shell的数量
## 1.() 可以开启子shell
## 2. & 也可以开启子shell
## 3.使用管道 | 也会开启子shell
## 4.变量替换 ${} 也会开启子shell
## 5. shell中通过相对路径和绝对路径执行命令  都会开启子进程 -- fork方式
## 6. exec方式 此会替换原来shell的数据

#### 
## 7. source 或者 . 在当前shell环境执行脚本,执行完成后继续执行脚本后续内容,并不会开启子shell