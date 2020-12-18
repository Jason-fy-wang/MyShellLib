#!/usr/bin/lua

--[[
optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
    function_body
    return result_params_comma_separated
end    

optional_function_scope: 指定是全局函数还是局部函数,未设置该参数认为全局函数,如果需要设置为局部函数,则使用关键字local
function_name: 函数名称
argument1, argument2, argument3..., argumentn: 参数
function_body: 函数体
result_params_comma_separated: 返回值; lua可以返回多个值,每个值以逗号隔开
--]]

function max(num1,num2)
    if (num1 > num2) then
        result = num1
    else
        result = num2
    end
    return result
end
print(max(10,15))

--lua中函数为一等公民,函数可以传递给 变量
myprint=function(param)
    print("print function - ##", param,"##")
end

function add(num1,num2,funcPrint)
    result = num1+num2
    funcPrint(result)
end
myprint(20)
add(10,20,myprint)

-- 查找数组最大值
function maxNum(a)
    local mi=1
    local m = a[mi]
    for i, val in ipairs(a) do
        if val > m then
            mi = i
            m = val
        end
    end
    return m,mi
end
print(maxNum({1,5,7}))

-- 可变参数
function sum(...)
    local s=0
    for i,v in ipairs{...} do
        s = s+v
    end
    return s
end

function avg(...)
    result = 0
    local arg={...}
    for i,v in ipairs(arg) do
            result = result + v
    end
    print("总共传入参数个数:", #arg)
    return result/#arg
end
-- 通过select("#",...) 来获取可变参数的数量
-- select(n,...), 返回n到 select("#",...)的参数
--
function avg2(...)
    result = 0
    local arg={...}
    for i,v in ipairs(arg) do
            result = result + v
    end
    print("总共传入参数个数:".. select("#",...))
    return result/select("#",...)
end



