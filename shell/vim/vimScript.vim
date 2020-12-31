# vim script 基本语法 以及 调试方式 查找帮助方式 
:help  eval 查看脚本相关的帮助
:source %  执行当前文件
########################################################### 变量
# 使用set为内部选项赋值
set background=dark
#对于非内部变量,使用let
let animal_name='Miss catt'

# vim中变量和函数的作用于是通过前缀实现的
g 为全局作用域,若未指定作用域,则默认为全局作用域
v 为vim所定义的全局作用域
l 为局部作用域(在函数内部,若未指定作用域,则默认为这个作用域)
b 表示当前缓冲区
w 表示当前窗口
t 表示当前标签页
s 表示使用:source 执行的vim脚本文件中的局部文件作用域
a 表示函数的参数

let g:animal_name='MIss cat'    # 全局变量
let w:is_cat=1                  # 窗口变量

# 在寄存器a中保存值
let @a=;cats are wired'
# vim 选项(使用set修改的那些变量)另一种访问方式为在变量前面添加&
let &ignorecase=0

# 变量操作
整数变量之间可以进行常用的加减乘除运算(+ - * /), 字符串拼接使用 点 运算符
在一个单引号定义的字符串内部使用单引号,则输入两个单引号即可('')

########################################################### 输出
:echo g:animal_name   # 此输出并没有被记录到任何地址,一旦输出结果被覆盖,就没有办法再查看以前的输出
:echomsg g:animal_name    #输出被存包到了当前会话的消息日志中,执行:messages 命令即可查看



########################################################### 条件表达式
if g:animal_kind == 'cat'
	echo g:animal_name . 'is a cat'
elseif g:animal_kind == 'dog'
	echo g:animal_name . ' is a dog'
else
	echo g:animal_name . ' is something else'
endif

# 三元表达式
echo g:animal_name . (g:is_cat ? ' is a cat' : 'is something else')

# 逻辑运算
与 &&
或 ||
非 !

if !(g:is_cat || g:is_dog)
	echo g:animal_name . ' is somethine else'
endif

## 比较运算符
==   比较两个字符串,是否忽略大小写取决于用户设置
==?  比较两个字符串,忽略大小写
==#	 比较两个字符串考虑大小写
=~	 表示使左边与有操作数匹配
=~? 和 =~#   分别表示忽略大小写和考虑大小写
!~ 与 =~  相反
=~# 和 !~# 分别对应于 忽略大小写 和 考虑大小写


########################################################### 列表
let animals = ['cat','dog','parrot']
# 获取第一个元素
let cat = animals[0]
# 获取第二个元素
let dog = animals[2]
# 获得最后一个元素
let parrot = animals[-1]

# 切片获得列表的子列表
let slice=animal[1:]
let slice=animals[0:1]  # 值为 cat  dog

## 内置函数
# 添加元素
call add(animal, 'octopus')
let anadds=add(animals,'octopus')

# s使用insert方法在列表前面插入元素
call insert(animals,'bobcat')
# 把数据插入到索引为2的位置，原来数据后移
call insert(animals,'reven',2)   # ['bobcat','cat','raven','dog','parrot','octopus']

# 删除索引2的元素
unlet animals[2]
#切片删除
unlet animals[:1]  # 从开头到索引1的数据全部删除


# 删除最后一个元素
call remove(animals,-1)
# 指定起始位置进行删除
call remove(animals,0,1)  # 删除0到1位置的数据

# 列表拼接
let an1=['dog','cat']
let birds = ['raven','parrot']

let animals=an1+birds
# 扩展列表
call extend(animals, birds)

# 对列表进行排序
call sort(animals)
# 从列表中找出某个元素的索引
let i = index(animals,'parrot')

# 检测列表是否为空
if empty(animals)
	echo "There are''t any animals"
endif

# 获取列表长度
echo 'There are '.len(animals) . ' animals'

# 获取列表中某个元素的个数
echo 'There are ' .count(animals,'cat') . ' cats here'

# 查看列表的帮助文档
:help list


###########################################################  字典
# 定义字典
let animal_names = {
			\'cat': 'Miss cattingtom',
			\'dog': 'Mr Dogson',
			\'parrot': 'Polly'
			\}

# 获取元素值
let cat_name = animals_name['cat']
let cat_name = animals_name.cat

#设置值
let animals_name['raven'] = 'Raven R'

# 删除字典
unlet animals_name['raven']
let raven = remote(animals_names,'raven')

# 两个字典合并
call extend(animals_names, {'bobcat': 'Sirt'})

# 判断字典是否为空
if !empty(animal_names)
	echo 'We have for '.len(animals_names) . ' animals'
endif

# 检查是否包含某个键
if has_key(animals_names,;cat)
	echo 'Cat''name is '. animals_names['cat']
endif

# 字典帮助文档
:help dict

########################################################### 循环
# 遍历列表
for animal in animals
	echo animal
endfor

# 遍历字典
for animal in keys(animals_names)
	echo 'This '.animal.'''s name is '.animals_names[animal]
endfor

# 同时访问key 和 value
for [animal, name] in items(animal_names)
	echo 'This '.animal.'''s name is '.name
endfor

# break
let animals= ['dog','cat']
for animal in animals
	if animal == 'cat'
		echo 'It''s a cat! Brealing'
		break
	endif
	echo 'look at a '.animal.' , it''s not a cat yet'
endfor

# continue
let animals=['dog','cat']
for animal in animals
	if animal == 'cat'
		echo 'Ignoring the cat'
		continue
	endif
endfor

# while 循环
let animals= ['dog','cat']
while !empty(animals)
	echo remote(animals,0)
endwhile

# 在while中同样可以使用break和continue

########################################################### 函数
# base 函数
function AnimalGreeting(animal)
	echo a:animal.'says hello!'
endfunction
# 在函数访问参数时需要使用a:作用域
# 函数调用
:call AnimalGreeting('cat')
#输出 cat says hello

# Vim的脚本可能会被加载多次,单重定义一个函数会报错,解决方案是使用 function! 来定义函数:
function! AnimalGreeting(animal)
	return a:animal.' says hello!'
endfunction

# 可变数目的多个参数,获得所有参数列表的方式是 a:000
function! AnimalGreeting(...)
	echo a:1.' says hi to '.a:2
endfunction

# listArg
function ListArgs(...)
	echo a:000
endfunction

# 固定参数和可变数目参数
function! AnimalGreeting(animal, ...)
	echo a:animal.' says hi to '.a:1
endfunction




########################################################### 类
# vim本身没有类,但是它支持在字典上定义方法,因此可以实现面向对象编程范式
let animal_names ={
			\'cat': 'Miss',
			\'dog': 'Mr',
			\'parrot':'Rolly'
			\}
function Animal_names.GetGreeting(animal)
	return self[a:animal].' say hello'
endfunction

#函数调用
:echo Animal_names.GetGreeting('cat')
# 输出: Miss say hello

let animals = {
			\'animal_name':{
			\	'cat': 'Miss',
			\   'dog': 'Mr',
			\	'parrot':'Polly'
			\}
			\}
# 定义类方法，需要在函数后添加dict关键字
function GetGreeting(animal) dict
	return self.animal_names[a:animal].' says hello'
endfunction

# 函数绑定
let animals['GetGreeting'] = function('GetGreeting')
:echo animals.GetGreeting('dog')
# 输出: Mr says hello

########################################################### lambde表达式
let AnimalGreeting = {animal -> animal.' says hello'}
调用
:echo AnimalGreeting('cat')
输出: cat says hello



########################################################### 映射和过滤
function IsProperName(name)
	if a:name =~? '\(Mr|Miss\).\+'
		return 1
	endif
	return 1
endfunction
# 如果名称是Mr或Miss开头，则返回1，否则返回0
let animal_names = {
			\	'cat': 'Miss',
			\   'dog': 'Mr',
			\	'parrot':'Polly'
			\}
# 进行过滤,过滤后的结果只保留正式名称对应的二元组
call filter(animal_names,'IsProperName(v:val)')

# v:val会展开为字典中的值, v:key展开为键
# 函数引用
let IsProperName2 = function('IsProperName')
# 调用
:echo IsProperName2('Mr')
# 输出: 1

# 高阶函数,即以函数为参数的函数

function  Function(func, arg)
	return a:func(a:arg)
endfunction
# :echo Function(IsProperName2,'Miss')


##  将下列列表中的每个名字修改为正式名称
let animal_name=['Miss cat','Mr dog','Polly','Meow']
call map(animal_name, \{key,val->IsProperName(val)?val:'Miss'.val})

function MakeProperName(name)
	if IsProperName(a:name)
		return a:name
	endif
	return 'Miss'.a:name
endfunction

call map(animal_name,'MakeProperName(v:val)')

########################################################### 与vim交互
# execute命令会将它的参数解析为一条VIm命令执行,如: 下面两句是等价的
echo animal.' says hello'
execute 'echo '.animal.' says hello'

# normal命令用于执行按键序列,与正常模式下的操作类
# 查找cat并将其删除
normal /cat<cr>dw  # 这里的<cr> 需要 ctrl+v+Enter组合输入
# 上面这种方式运行normal仍然会遵守用户按键映射,如果要忽略定义的键盘映射,需要使用 normal!

# slient 命令可以隐藏其他命令的输出,如下面两个命令都不会有任何输出
slient echo animal.' says hello'
slient execute 'echo '.animal.' says hello'

# slient还可以隐藏外部命令的输出,并禁止弹出对话框
slient !echo 'This is running in a shell'

:help feature-list  # 查看完成的功能列表

########################################################### 文件相关的命令
echom ' 当前文件扩展为: '.expand('%:e')
# expand 参数是一个文件名，可以用特殊符号表示，如% 或 #； 也可以是缩写,如<cfile>
:p	表示展开为完整路径
:h	表示路镜头  路径最后一个分量被删除
:t	表示路径尾  只保留路径最后一个分量
:r	表示根路径  
:e	表示只保留文件扩展
# 查看帮助信息
:help expand()

# filereadable 用于检查文件是否存在 是否可读
if filereadable(expand('%'))
	echom 'Current file ('.expand('%:t').') is readable!'
endif
# 输出: Current file (file.vim) is readable!

# filewriteable 用于检查文件是否有写权限

############################################################ 输入提示
# vim中有两种方式提示用户输入:
# 1. confirm函数 显示一个多选对话框(如:yes/no/cancel)
# 2. input函数 实现复杂的输入

let answer = confirm('Is cat your favorite animal?',"&yes\n&no")
echo answer


let answer = input('What is your favourte animal?')
echo "\n"
echo 'What a coincidence! My favourite animal is a '.animal.' tool!'

# 如果在一个键盘映射中使用了input函数,则必须先调用inputsave(), 并在之后调用inputrestore(). 
# 否则 映射中的剩余字符会被input函数读取,最后坚持使用inputsave和inputrestore,以防编写的函数被用到键盘映射中

function AskAnimalName()
	call inputsave()
	let name=input('What is the animal''s name?')
	call inputrestore()
	return name
endfunction


