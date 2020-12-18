#!/usr/bin/lua

-- 接收传递的参数

function printArg()
    print("arg size=",#arg)
    print("arg[0]=",arg[0])
    print("arg[1]=",arg[1])
    print("arg[2]=",arg[2])
    print("arg[3]=",arg[3])
end

printArg()
