#!/usr/bin/lua


-- while循环
a=10
while(a < 20)
do
 print("a values:",a)
 a = a+1
end


--[[
for var=exp1,exp2,exp3 do
    <statement>
end
var从exp1变化到exp2,每次变化以exp3为步长递增var; exp3是可选的,不指定,默认为1
--]]
for i=10,1,-1 do
    print(i)
end

a={"one","two","three"}
for i,v in ipairs(a) do
    print(i,v)
end


-- repeat
b=10
repeat
    print("b valu=",b)
    b=b+1
until(b>15)

-- goto
local b1 = 1
::label:: print("---goto label----")

b1=b1+1
if b1 < 3 then
    goto label  -- a小于3时跳转
end

-- if .. else
b3=30
if(b3<40)
then
    print("b3 less than 40")
else
    print("b3 greater than 40")
end

b4=15
if(b4>=100) then
    print("b4 greater than 100")
elseif (b4 > 90) then
    print("b4 greater than 90")
elseif (b4 >80) then
    print("b4 greater than 80")
else
    print("b4 less than 80")
end



