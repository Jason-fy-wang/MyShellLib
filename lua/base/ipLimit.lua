
-- IP 限流,对某个ip频率进行限制,1分钟访问10次
local num=redis.call('incr', KEYS[1])
if tonumber(num) > tonumber(ARGV[2]) then
    return 0
else 
    return 1
end

-- EVAL script numkeys key [key …] arg [arg …]

-- ./redis-cli –eval [lua脚本] [key…]空格,空格[args…]
-- redic-cli --eval "ipLimit.lua" 192.168.1.15 , 6000  10

--[[
evalsha 缓存 脚本的执行

redis.log()  -- 可以输出日志到redis的日志文件中, 具体的其他函数可以查看redis官方的lua脚本章节

92:0>script load "return redis.call('set',KEYS[1],ARGV[1])"    # 这段脚本 生成了SHA1 值，来标记其唯一性
"c686f316aaf1eb01d5a4de1b0b63cd233010e63d"                                     
92:0>evalsha "c686f316aaf1eb01d5a4de1b0b63cd233010e63d" 1 AA BB   # 使用 evalsha 命令 和 SHA1 值来执行脚本
"OK"
92:0>get AA          # 验证数据存储是否成功
"BB"
--]]