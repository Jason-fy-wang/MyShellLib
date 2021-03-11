## redis 执行lua脚本

# 1. 基本用法
EVAL script numberkeys  key [key...] [arg] [arg...]
6379> eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 arg1 args
1)"key1"
2)"key2"
3)"arg1"
4)"arg2"

# 2.SCRIPT LOAD script 把脚本加载到脚本缓存中,返回sha1校验和,但不会立马执行
6379> SCRIPT LOAD "return 'hello world'"
"5332031c6b470dc5a0dd9b4bf2030dea6d65de91"

# 3. evalsha sha1 numberkeys key [key...] arg [arg...]
127.0.0.1:6379> SCRIPT LOAD "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 
"a42059b356c875f0717db19a51f6aaca9ae659ea"
127.0.0.1:6379> EVALSHA "a42059b356c875f0717db19a51f6aaca9ae659ea" 2 key1 key2 val1 val2
1) "key1"
2) "key2"
3) "val1"
4) "val2"

# 4. SCRIPT EXISTS script [script]
通过sha1校验和判断脚本是否在缓存中

## 5. script flush
清空缓存
127.0.0.1:6379> SCRIPT LOAD "return 'hello jihite'"
"3a43944275256411df941bdb76737e71412946fd"
127.0.0.1:6379> SCRIPT EXISTS "3a43944275256411df941bdb76737e71412946fd"
1) (integer) 1
127.0.0.1:6379> SCRIPT FLUSH
OK
127.0.0.1:6379> SCRIPT EXISTS "3a43944275256411df941bdb76737e71412946fd"
1) (integer) 0



## 6. script kill
杀死目前正在执行的脚本

优势：
1. 较少网络开销: 多个请求通过脚本一次发送,减少网络延迟
2. 原子操作: 将脚本作为一个整体执行, 中间不会执行其他命令,无需使用事务
3. 复用: 客户端发送的脚本永久存在redis中, 其他客户端可以复用脚本
4. 可嵌入性: 可嵌入java, c# 等多种编程语言, 支持不同操作系统跨平台交互

执行一个lua脚本:
脚本位置: /opt/redlua1.lua
if redis.call("EXISTS", KEYS[1]) == 1 then
    return redis.call("INCRBY", KEYS[1],ARGV[1])
    else
    return nil
end

$ redis-cli --evel /opt/redlua1.lua usr , 1


