# 从命令行 参数传递一个文件进来，并进行读取处理
# /\bfred\b/i  此正则表示 不区分大小写来查找包含 fred的行
# <>  读取命令行传递进来的文件
my @res = grep /\bfred\b/i,<>;
print"res = @res";