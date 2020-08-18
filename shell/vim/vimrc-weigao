"必须的设置：

"关闭文件类型侦测
 filetype off
"根据侦测到的不同类型加载对应的插件
 filetype plugin on
"为特定文件类型载入相关缩进文件
 filetype indent on
" 开启语法高亮功能
 syntax enable
" 允许用指定语法高亮配色方案替换默认方案
 syntax on
" 关闭兼容模式, 不要兼容vi
 set nocompatible "不要vim模仿vi模式，建议设置，否则会有很多不兼容的问题

"配色方案
 colorscheme mycolor
 set background=dark "背景使用黑色
"terminal下面的背景问题
 let g:solarized_termtrans=1
 let g:solarized_termcolors=256
 let g:solarized_contrast="high"
 let g:solarized_visibility="high"

 set modelines=0

"tab键的设定
"设置编辑时制表符占用空格数
 set tabstop=4
"设置格式化时制表符占用空格数
 set shiftwidth=4
"让 vim 把连续数量的空格视为一个制表符, 使得按退格键时可以一次删掉 4 个空格
 set softtabstop=4
"用空格代替制表符
 set expandtab
"不要用空格代替制表符
"set noexpandtab

"字符设置
 set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5
"set encoding=utf-8
"set helplang=cn
 set scrolloff=3 " 光标移动到buffer的顶部和底部时保持10行距离
"新建文件编码
 set fenc=utf-8
 set autoindent
 set hidden                  " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
"高亮显示当前行/列
 set cursorline
"set cursorcolumn
 set ttyfast
"显示光标当前位置
 set ruler                   " 打开状态栏标尺
 set backspace=indent,eol,start
 set laststatus=2            " 启动显示状态行(1),总是显示状态行(2)
"相对行号 要想相对行号起作用要放在显示行号后面
"set relativenumber
"开启行号显示
 set number
"无限undo
"set undofile
"自动换行
"set wrap
"禁止自动换行
 set nowrap
"GUI界面里的字体，默认有抗锯齿
" set guifont=Inconsolata:h12
"自动载入配置文件不需要重启
"autocmd! bufwritepost _vimrc source %
"将-连接符也设置为单词
 set isk+=-

set ignorecase smartcase    " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
"设置大小写敏感和聪明感知(小写全搜，大写完全匹配)
" 搜索时大小写不敏感
 set ignorecase
 set smartcase
"set gdefault
" 开启实时搜索功能
 set incsearch
" 高亮显示匹配的括号
 set showmatch
 set hlsearch
"搜索逐字符高亮
set incsearch               " 输入搜索内容时就显示搜索结果
set hlsearch                " 搜索时高亮显示被找到的文本
" 高亮显示搜索结果
set hlsearch

"加入html标签配对
"runtime macros/matchit.vim

"以下设置用来是vim正确显示过长的行
"set textwidth=80
"set formatoptions=qrnl
"彩色显示第85行
 set colorcolumn=85
"设置256色显示
 set t_Co=256

"行号栏的宽度
 set numberwidth=4
"初始窗口的宽度
"set columns=135
"初始窗口的高度
"set lines=50
"初始窗口的位置
"winpos 620 45

"匹配括号的规则，增加针对html的<>
"set matchpairs=(:),{:},[:],<:>
"让退格，空格，上下箭头遇到行首行尾时自动移到下一行（包括insert模式）
 set whichwrap=b,s,<,>,[,]

"插入模式下移动
 inoremap <c-j> <down>
 inoremap <c-k> <up>
 inoremap <c-l> <right>
 inoremap <c-h> <left>

"===================================================
"leader键的功能设置
"修改leader键为逗号
 let mapleader=","
"esc的映射
 imap jj <esc>
"屏蔽掉讨厌的F1键
 inoremap <F1> <ESC>
 nnoremap <F1> <ESC>
 vnoremap <F1> <ESC>
"修改vim的正则表达
 nnoremap / /\v
 vnoremap / /\v
"使用tab键来代替%进行匹配跳转
 nnoremap <tab> %
 vnoremap <tab> %
"折叠html标签 ,fold tag
 nnoremap <leader>ft vatzf
"使用,v来选择刚刚复制的段落，这样可以用来缩进
 nnoremap <leader>v v`]
"使用,w来垂直分割窗口，这样可以同时查看多个文件,如果想水平分割则<c-w>s
 nnoremap <leader>w <c-w>v<c-w>l
 nnoremap <leader>wc <c-w>c
 nnoremap <leader>ww <c-w>w
"使用<leader>t来控制Tab的切换
 nnoremap <leader>t gt
 nnoremap <leader>r gT
"使用<leader>空格来取消搜索高亮
 nnoremap <leader><space> :noh<cr>
"html中的js加注释 取消注释
 nmap <leader>h I//jj
 nmap <leader>ch ^xx
"切换到当前目录
 nmap <leader>q :execute "cd" expand("%:h")<CR>
"搜索替换
 nmap <leader>s :,s///c

"选中状态下 Ctrl+c 复制
 vmap <C-c> "+y

" 设置当文件被改动时自动载入
" set autoread

"取消粘贴缩进
 nmap <leader>p :set paste<CR>
 nmap <leader>pp :set nopaste<CR>

"文件类型切换
 nmap <leader>fj :set ft=javascript<CR>
 nmap <leader>fc :set ft=css<CR>
 nmap <leader>fx :set ft=xml<CR>
 nmap <leader>fm :set ft=mako<CR>

"设置隐藏gvim的菜单和工具栏 F2切换
 set guioptions-=m
 set guioptions-=T
"去除左右两边的滚动条
 set go-=r
 set go-=L

 map <silent> <F2> :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR>

" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
 set mouse=a
 set selection=exclusive
 set selectmode=mouse,key
" 开启鼠标支持
 set mouse=a
" 查找并启用tag
 set tags=tags;

" Space to command mode.
 nnoremap <space> :
 vnoremap <space> :

"===================================================
" 插件的设置

" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles

if ! isdirectory($HOME."/.vim/bundle/vundle")
    echo "you should setup vundle frist!"
    echo "use \"git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle\""
else

" 刷新插件
 nmap <F10> :BundleInstall<cr>
" 更新插件
 nmap <S-F9> :BundleSearch<cr>

" Indent Guides设置
 let g:indent_guides_guide_size=1

 set rtp+=~/.vim/bundle/vundle/
 call vundle#rc()

" let Vundle manage Vundle
" required!
 Bundle 'gmarik/vundle'
"---------------------------------------------------

"---------------------------------------------------

 Bundle 'Tabular'

"---------------------------------------------------

"和snipmate 冲突
if v:version == 704
"    has('python')    Bundle 'Valloric/YouCompleteMe'
" Bundle 'Valloric/YouCompleteMe'
 nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
 nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
 let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
 let g:ycm_confirm_extra_conf = 0 "Do not ask when starting vim
 let g:syntastic_always_populate_loc_list = 1
endif

"---------------------------------------------------

" jsbeautify的设置
 Bundle '_jsbeautify'
 nnoremap <leader>_ff :call g:Jsbeautify()<CR>

"---------------------------------------------------

" EasyMotion设置
 Bundle 'EasyMotion'
 let g:EasyMotion_leader_key = '<Leader><Leader>'

"---------------------------------------------------

" Fencview的初始设置
 Bundle 'FencView.vim'
 let g:fencview_autodetect=1

"---------------------------------------------------

" NerdTree的设置 并且相对行号显示
" plugin - NERD_tree.vim 以树状方式浏览系统中的文件和目录
" :ERDtree 打开NERD_tree         :NERDtreeClose    关闭NERD_tree
" o 打开关闭文件或者目录         t 在标签页中打开
" T 在后台标签页中打开           ! 执行此文件
" p 到上层目录                   P 到根目录
" K 到第一个节点                 J 到最后一个节点
" u 打开上层目录                 m 显示文件系统菜单（添加、删除、移动操作）
" r 递归刷新当前目录             R 递归刷新当前根目录
 Bundle 'The-NERD-tree'
 nmap <leader>nt :NERDTree<cr>:set rnu<cr>
"nmap  <F3> :NERDTreeToggle<cr>
"imap <F3> <ESC>:NERDTreeToggle<CR>
 let NERDTreeShowBookmarks=1
 let NERDTreeShowFiles=1
 let NERDTreeShowHidden=1
 let NERDTreeIgnore=['\.$','\~$']
 let NERDTreeShowLineNumbers=1
 let NERDTreeWinPos=1
"let g:NERDTreeWinPos="right"
"let g:NERDTreeWinSize=25
"let g:NERDTreeQuitOnOpen=1

"---------------------------------------------------

"对NERD_commenter的设置
" 功能强大的代码注释工具,用来注释或者取消注释,支持很多语言,可以对文本块操作,最常用到的快捷键是\c<space>
" plugin - NERD_commenter.vim   注释代码用的，
" [count],cc 光标以下count行逐行添加注释(7,cc)
" [count],cu 光标以下count行逐行取消注释(7,cu)
" [count],cm 光标以下count行尝试添加块注释(7,cm)
" ,cA 在行尾插入 /* */,并且进入插入模式。 这个命令方便写注释。
" 注：count参数可选，无则默认为选中行或当前行
 Bundle 'The-NERD-Commenter'
 let NERDSpaceDelims=1       " 让注释符与语句之间留一个空格
 let NERDCompactSexyComs=1   " 多行注释时样子更好看
 let NERDShutUp=1
" 支持单行和多行的选择，//格式
 map <C-h> ,c<space>

"---------------------------------------------------

" 在.c/.h之间切换,写代码必备
 Bundle 'a.vim'
" A few of quick commands to swtich between source files and header files quickly.
"
" :A switches to the header file corresponding to the current file being
" edited (or vise versa)
" :AS splits and switches
" :AV vertical splits and switches
" :AT new tab and switches
" :AN cycles through matches
" :IH switches to file under cursor
" :IHS splits and switches
" :IHV vertical splits and switches
" :IHT new tab and switches
" :IHN cycles through matches
" <Leader>ih switches to file under cursor
" <Leader>is switches to the alternate file of file under cursor (e.g. on
" <foo.h> switches to foo.cpp)
" <Leader>ihn cycles through matches
"
" E.g. if you are editing foo.c and need to edit foo.h
" simply execute :A and you will be editting foo.h,
" to switch back to foo.c execute :A again.
"
" Can be configured to support a variety of languages. Builtin support for
" C, C++ and ADA95

"---------------------------------------------------

if has("cscope")
 Bundle 'cscope.vim'
    set cscopetag
    set cscopeverbose 
    " nmap s :cs find s =expand("")   
    " nmap g :cs find g =expand("")   
    " nmap c :cs find c =expand("")   
    " nmap t :cs find t =expand("")   
    " nmap e :cs find e =expand("")   
    " nmap f :cs find f =expand("")   
    " nmap i :cs find i ^=expand("")$
    " nmap d :cs find d =expand("")   
    " nmap s :scs find s =expand("")  
    " nmap g :scs find g =expand("")  
    " nmap c :scs find c =expand("")  
    " nmap t :scs find t =expand("")  
    " nmap e :scs find e =expand("")  
    " nmap f :scs find f =expand("")  
    " nmap i :scs find i ^=expand("")$
    " nmap d :scs find d =expand("")  
    " nmap s :vert scs find s =expand("")
    " nmap g :vert scs find g =expand("")
    " nmap c :vert scs find c =expand("")
    " nmap t :vert scs find t =expand("")
    " nmap e :vert scs find e =expand("")
    " nmap f :vert scs find f =expand("")  
    " nmap i :vert scs find i ^=expand("")$
    " nmap d :vert scs find d =expand("")
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set csto=0
    set cst
    set nocsverb
    if filereadable("cscope.out") " add any database in current directory
        cs add cscope.out
    elseif $CSCOPE_DB != "" " else add database pointed to by environment
        cs add $CSCOPE_DB
    endif
    set csverb " 这个必须放在后面,不然windows上找不到cscope.out

 nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR> :cw<CR>
 nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR> :cw<CR>
 nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR> :cw<CR>
 nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR> :cw<CR>
 nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR> :cw<CR>
 nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR> :cw<CR>
 nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> :cw<CR>
 nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR> :cw<CR>
"nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"nmap <leader>ss :cs find s <C-R>=expand("<cword>")<cr><cr>
"nmap <leader>sg :cs find g <C-R>=expand("<cword>")<cr><cr>
"nmap <leader>sc :cs find c <C-R>=expand("<cword>")<cr><cr>
"nmap <leader>st :cs find t <C-R>=expand("<cword>")<cr><cr>
"nmap <leader>se :cs find e <C-R>=expand("<cword>")<cr><cr>
"nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<cr><cr>
"nmap <leader>si :cs find i <C-R>=expand("<cfile>")<cr><cr>
"nmap <leader>sd :cs find d <C-R>=expand("<cword>")<cr><cr>
"nmap <F2>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"nmap <F2>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <F2>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"nmap <F2>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"nmap <F2>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"nmap <F2>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR><CR>
"nmap <F2>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR><CR>
"nmap <F2>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR><CR>
"nmap <C-]> :tjump <C-R>=expand("<cword>")<CR><CR>
""nmap <C-]> :cs find g <C-R>=expand("<cword>")<CR><CR><CR>
"if filereadable("cscope.out")
"    execute "cs add cscope.out"
"endif

"Using 'CTRL-spacebar' then a search type makes the vim window
"split horizontally, with search result displayed in
"the new window.
"nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

"Hitting CTRL-space *twice* before the search type does a vertical
"split instead of a horizontal one
"nmap <C-Space><C-Space>s:vert scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>g:vert scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>c:vert scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>t:vert scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>e:vert scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space><C-Space>i:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space><C-Space>d:vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif

"---------------------------------------------------

"omnicppcomplete会打开一个预览窗口来提示变量定义，如果不想要看到详细的信息的话，在vimrc中这样配置
 Bundle 'OmniCppComplete'
 set completeopt=longest,menu
"搜索字符串，或以递增方式搜索字符串
 let Grep_Default_Filelist = '*.[chS]'
 let Grep_Default_Filelist = '*.c *.cpp *.asm'
 let Grep_Skip_Files = '*tags* *cscope* *.o* *.lib *.a* *.r* *.d*'
 nnoremap <silent> <C-f> :Rgrep<CR><CR><CR><CR>
 nnoremap <silent> <C-g> :RgrepAdd<CR><CR><CR><CR>
 set nocp
 set completeopt=menu "去掉提示窗口"
 filetype plugin on
 let OmniCpp_DefaultNamespaces = ["std"] "下面的设置用于当用户预先声明namespace时也能自动补全代码（如使用using std::string）
 let OmniCpp_NamespaceSearch = 1
 let OmniCpp_GlobalScopeSearch = 1
 let OmniCpp_ShowAccess = 1
 let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表
 let OmniCpp_MayCompleteDot = 1 " 输入 . 后自动补全
 let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全
 let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全
 let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
 let OmniCpp_SelectFirstItem=2

"---------------------------------------------------

 Bundle 'tComment'

"---------------------------------------------------

" 在输入()等需要配对的符号时，自动帮你补全剩余半个
"Bundle 'AutoClose'

"---------------------------------------------------

 Bundle 'command-t'

"---------------------------------------------------

"  Bundle 'Lokaltog/vim-powerline'
" " mkfontscale
" " mkfontdir
" " fc-cache -vf
" " rm ~/.vim/bundle/vim-powerline/*.cache
" " https://github.com/eugeii/consolas-powerline-vim.git
" " https://github.com/powerline/fonts.git
"  set guifont=PowerlineSymbols\ for\ Powerline
"  let g:Powerline_symbols = 'fancy'

"---------------------------------------------------

"plugin - taglist.vim  查看函数列表，需要ctags程序
"  Bundle 'taglist.vim'
"  nmap  <F2> :TlistToggle<cr>
"nnoremap <silent><F4> :TlistToggle<CR>
 let Tlist_Auto_Open = 0                " 默认打开Taglist
 let Tlist_Auto_Update = 1
 let Tlist_Compact_Format = 1 " 压缩方式
 let Tlist_Display_Prototype = 0
 let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树 (鼠标可以点开)
 let Tlist_Exit_OnlyWindow = 1          " 如果taglist窗口是最后一个窗口，则退出vim
"let Tlist_Exist_OnlyWindow = 1 " 如果只有一个buffer，kill窗口也kill掉buffer
 let Tlist_File_Fold_Auto_Close=1       " 自动折叠当前非编辑文件的方法列表
"let Tlist_File_Fold_Auto_Close = 0 " 不要关闭其他文件的tags
 let Tlist_Hightlight_Tag_On_BufEnter = 1
 let Tlist_Inc_Winwidth = 0 "标签列表窗口显示或隐藏不影响整个gvim窗口大小
 let Tlist_Process_File_Always = 1 "不是一直实时更新tags，因为没有必要
 let Tlist_Show_One_File = 1 " 设置tablist插件只显示当前编辑文件的tag内容，而非当前所有打开文件的tag内容
"let Tlist_Use_Right_Window = 1         " 在右侧窗口中显示taglist窗口
 let Tlist_WinWidth = 25 " taglist窗口宽度
 let g:Tlist_Auto_Highlight_Tag=1
 nmap <silent> <leader>tl :Tlist<cr>
let Tlist_Sort_Type            = "name"    " 按照名称排序
let Tlist_Compart_Format       = 1    " 压缩方式

"进行Tlist的设置
"TlistUpdate可以更新tags
map <F8> :silent! Tlist<CR>
let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Ctags_Cmd        = '/usr/bin/ctags'
let Tlist_Show_One_File=1 "让taglist可以同时展示多个文件的函数列表，如果想只有1个，设置为1
"是否一直处理tags.1:处理;0:不处理
let Tlist_Inc_Winwidth=0

"---------------------------------------------------

 Bundle 'snipMate'

"---------------------------------------------------

" 一些插件依赖的库函数
"   genutils(2.5)底层的lookupfile的功能支持+
 Bundle 'genutils'

"---------------------------------------------------

" lookupfile.vim 使用部分关键字查找文件名
 Bundle 'lookupfile'
 nmap  <F5> <Plug>LookupFile<cr>
let g:LookupFile_MinPatLength           = 2 "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern    = 0 "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1 "保存查找历史
let g:LookupFile_AlwaysAcceptFirst      = 1 "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles          = 0 "不允许创建不存在的文件
let g:LookupFile_SortMethod             = "" "关闭对搜索结果的字母排序
"if filereadable("/home/ganquan/linux-2.6.34-rc4/filenametags")
"设置tag文件的名字
"let g:LookupFile_TagExpr ='"/home/ganquan/linux-2.6.34-rc4/filenametags"'
"endif

"---------------------------------------------------
"智能补全
 Bundle 'supertab'
"---------------------------------------------------
" 给vim增加IDE的功能,提供目录浏览和buffer浏览功能,因为显示器太小,感觉太占空间,所以单独使用bufexplorer,而且现在vim7的netrw功能也够强大,所以感觉比较鸡肋,而且貌似很久没有更新,所以基本不用
Bundle 'winmanager'
" let g:winManagerWindowLayout='NERDTree|TagList'
nmap wm :if IsWinManagerVisible() <BAR> WMToggle<CR> <BAR> else <BAR> WMToggle<CR>:q<CR> endif <CR><CR>
let g:winManagerWindowLayout='NERDTree|BufExplorer'
"let g:winManagerWindowLayout = 'FileExplorer|TagList'
"let g:winManagerWindowLayout = 'FileExplorer'
let g:winManagerWidth = 25
let g:defaultExplorer = 0
nmap wm :WMToggle<cr>
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
autocmd BufWinEnter \[Buf\ List\] setl nonumber
"---------------------------------------------------
 Bundle 'biogoo.vim'
 Bundle 'gtrans.vim'
"---------------------------------------------------

" plugin - NeoComplCache.vim    自动补全插件
 Bundle 'neocomplcache'
let g:AutoComplPop_NotEnableAtStartup = 1
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_TagsAutoUpdate = 1
let g:NeoComplCache_EnableInfo = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_MinSyntaxLength = 3
let g:NeoComplCache_EnableSkipCompletion = 1
let g:NeoComplCache_SkipInputTime = '0.5'
let g:NeoComplCache_SnippetsDir = $VIMFILES.'/snippets'
" <TAB> completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" snippets expand key
imap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)
smap <silent> <C-e> <Plug>(neocomplcache_snippets_expand)

"---------------------------------------------------

Bundle 'mhinz/vim-startify'
Bundle 'jlanzarotta/bufexplorer'
"---------------------------------------------------

Bundle 'majutsushi/tagbar'
" let tagbar_ctags_bin=ctags
" 设置 tagbar 子窗口的位置出现在主编辑区的左边 
let tagbar_left=1 
" 设置显示／隐藏标签列表子窗口的快捷键。速记：tag list 
" nnoremap <Leader>tl :TagbarToggle<CR> 
nmap tb :Tagbar<cr>
" 设置标签子窗口的宽度 
let tagbar_width=32 
" tagbar 子窗口中不显示冗余帮助信息 
let g:tagbar_compact=1
" 设置 ctags 对哪些代码元素生成标签
let g:tagbar_type_cpp = {
  \ 'kinds' : [
    \ 'd:macros:1',
    \ 'g:enums',
    \ 't:typedefs:0:0',
    \ 'e:enumerators:0:0',
    \ 'n:namespaces',
    \ 'c:classes',
    \ 's:structs',
    \ 'u:unions',
    \ 'f:functions',
    \ 'm:members:0:0',
    \ 'v:global:0:0',
    \ 'x:external:0:0',
    \ 'l:local:0:0'
   \ ],
   \ 'sro'      : '::',
   \ 'kind2scope' : {
     \ 'g' : 'enum',
     \ 'n' : 'namespace',
     \ 'c' : 'class',
     \ 's' : 'struct',
     \ 'u' : 'union'
   \ },
   \ 'scope2kind' : {
     \ 'enum'     : 'g',
     \ 'namespace' : 'n',
     \ 'class'   : 'c',
     \ 'struct' : 's',
     \ 'union'   : 'u'
   \ }
\ }

"---------------------------------------------------

 Bundle 'terryma/vim-multiple-cursors'
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"---------------------------------------------------

" color theme浏览插件,列出所有的vim color theme到一个列表中,选中后按回车即可应用相应的color theme,试验color theme时再也不用一次次输入:colo theme_name了,从上百个color theme中选择自己喜欢的theme时有用
Bundle 'sjas/csExplorer'

"---------------------------------------------------

" 一个对齐的插件,用来排版,面对一堆乱七八糟的代码时,用来对齐代码,功能强大,不过用到的机会不多
Bundle 'Align'

"---------------------------------------------------

Bundle 'checksyntax'

"---------------------------------------------------

" 在vim里画图
Bundle 'DrawIt'

"---------------------------------------------------

"显示git diff的插件
 Bundle 'airblade/vim-gitgutter'

"---------------------------------------------------

" 日历插件,有了它,用vim来写日记很方便
 Bundle 'itchyny/calendar.vim'
let g:calendar_frame = 'default'

"---------------------------------------------------

" Bundle 'bling/vim-airline'
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" " let g:airline_powerline_fonts = 2
" if !exists('g:airline_symbols')
"       let g:airline_symbols = {}
"   endif
"   let g:airline_symbols.space = "\ua0"

"---------------------------------------------------

"可视化的方式能将相同缩进的代码关联起来
"  Bundle 'nathanaelkane/vim-indent-guides'
 " 随 vim 自启动
 let g:indent_guides_enable_on_vim_startup=1
 " 从第二层开始可视化显示缩进
 let g:indent_guides_start_level=2
 " 色块宽度
 let g:indent_guides_guide_size=1
 " 快捷键 i 开/关缩进可视化
"  :nmap <silent> <Leader>i <Plug>IndentGuidesToggle

"---------------------------------------------------
"让书签可视化的插件
 Bundle 'kshenoy/vim-signature'
"---------------------------------------------------

"Fugitive: Git 集成，强烈推荐！Plugin 'tpope/vim-fugitive'
 Bundle 'fugitive.vim'
"在两端加上、修改、删除匹配的符号如（）
"Bundle 'vim-surround'
 " vim帮助中文版
"Bundle 'vimcdoc'
"Bundle 'altercation/vim-colors-solarized'   " Solarized: 非常流行的配色。
"Bundle 'EnhancedCommentify' " 多文本类型的快捷comment/uncomment, 据说NERD Commenter 更好一些
"Bundle 'surround'           " 用来加括号，引号，前后缀等等，写XML很有用（特别是配合repeat）
"Bundle 'manpageview'        " 在Vim中查看Manpage，有语法高亮
"Bundle 'VCScommand'         " 支持多种版本管理器
"Bundle 'cctree'             " 可以查看function的call tree
" vim自带的文件浏览器
"Bundle 'netrwPlugin.vim'

"---------------------------------------------------

" Bundle 'SirVer/ultisnips'
" Bundle 'UltiSnips'
" " Trigger configuration. Do not use <tab>
" "if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<c-j>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" Bundle 'UltiSnips'

"---------------------------------------------------

" 同时高亮多个单词
" plugin - mark.vim 给各种tags标记不同的颜色，便于观看调式的插件。
" \m  mark or unmark the word under (or before) the cursor
" \r  manually input a regular expression. 用于搜索.
" \n  clear this mark (i.e. the mark under the cursor), or clear all highlighted marks .
" \*  当前MarkWord的下一个     \#  当前MarkWord的上一个
" \/  所有MarkWords的下一个    \?  所有MarkWords的上一个

"---------------------------------------------------

"显示缩进对齐线
Bundle 'Yggdroot/indentLine'
map <leader>il :IndentLinesToggle<CR>

"---------------------------------------------------

" 使用 ctrlsf.vim 插件在工程内全局查找光标所在关键字，设置快捷键。快捷键速记法：search in project
" ack 后端， 需要ack版本不低于2.0
" 可以键入 p 键，将在右侧子窗口中给出该匹配项的完整代码，而不再仅有前后几行。
" 不想跳至任何匹配项，可以直接键入  q 退出 ctrlsf.vim；如果有钟意的匹配项，
" 光标定位该项后回车，立即跳至新 buffer 中对应位置。

if has('ack')
Bundle 'dyng/ctrlsf.vim'
Bundle 'ack.vim'
endif

nnoremap <Leader>sp :CtrlSF<CR>
"---------------------------------------------------
" vim-scripts repos
" Bundle 'ctrlp.vim'
" Bundle 'ShowTrailingWhitespace'
Bundle 'sjl/gundo.vim'
" Bundle 'ack'
" Bundle 'vim-git'
" Bundle 'pep8'
" Bundle 'TaskList.vim'
Bundle 'reinh/vim-makegreen'
" Bundle 'tpope/vim-surround'
" Bundle 'getscriptPlugin.vim'
" 工程内查找与替换+
Bundle 'grep.vim'
" Bundle 'gzip.vim'
" Bundle 'rrhelper.vim'
" Bundle 'spellfile.vim'
" Bundle 'tarPlugin.vim'
" Bundle 'winfileexplorer.vim'
" Bundle 'wintagexplorer.vim'
Bundle 'bash-support.vim'
" Bundle 'code_complete.vim'
" Bundle 'cuteErrorMarker.vim'
" Bundle 'mru.vim'
" Bundle 'JSON.vim'
" Bundle 'gtags.vim'
" Bundle 'gtk-vim-syntax'
" Bundle 'jQuery'
" Bundle 'Stormherz/tablify'
" Bundle 'guns/ultisnips'
" Bundle 'jiazhoulvke/MarkdownView'
" Bundle 'jiazhoulvke/googletranslate'
" Bundle 'jiazhoulvke/imagemap'
" Bundle 'jiazhoulvke/jianfan'
" Bundle 'jiazhoulvke/myproject'
" Bundle 'shawncplus/phpcomplete.vim'
" Bundle 'tpope/vim-markdown'
" Bundle 'xolox/vim-lua-ftplugin'
" Bundle 'xolox/vim-misc'
" Bundle 'xolox/vim-session'
" Bundle 'EasyGrep'
" Bundle 'Mark--Karkat'
" Bundle 'Shougo/unite-help'
" Bundle 'Shougo/unite-outline'
" Bundle 'Shougo/unite.vim'
" Bundle 'Shougo/vimproc.vim', { 'build' : { 'unix' : 'make -f make_unix.mak', }, }
" Bundle 'Shougo/vimshell.vim'
" Bundle 'chrisbra/csv.vim'
" Bundle 'cscope_macros.vim'
" Bundle 'mhinz/vim-signify'
" Bundle 'mhinz/vim-startify'
" Bundle 'osyo-manga/unite-quickfix'
" Bundle 'tpope/vim-speeddating'
" Bundle 'tsukkee/unite-tag'

"---------------------------------------------------
"repeat 支持使用.来重复执行一些插件的命令（如speeddating, surround等)
" Bundle 'repeat.vim'

" 切换缓冲区
" minibufexpl插件的一般设置
let g:miniBufExplMapWindowNavVim    = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs  = 1
let g:miniBufExplModSelTarget       = 1
"let g:miniBufExplorerMoreThanOne   = 1 "自动打开

Bundle 'fholgado/minibufexpl.vim'
" 显示/隐藏 MiniBufExplorer 窗口
map <Leader>bl :MBEToggle<cr>
" buffer 切换快捷键
map <C-Tab> :MBEbn<cr>
map <C-S-Tab> :MBEbp<cr>

" original repos on github
" Bundle 'mattn/emmet-vim'

" coffee-scrpit support
" Bundle 'kchmck/vim-coffee-script'

" better color
" Bundle 'tomasr/molokai'

" 神级插件，ZenCoding(原名)可以让你以一种神奇而无比爽快的感觉写HTML、CSS
"  Bundle 'ZenCoding.vim'

" c/c++ support,让你用编写c/c++程序时如虎添翼,有很多贴心的功能,每个功能都有快捷键,不过一部分和NERD_comments冲突 如果经常编写一些单文件的c程序,但是不想写makefile,用这个,他帮你完成,F9编译并链接,ctrl-F9运行
" c.vim

" FuzzyFinder缓冲器/文件/命令/标签/等浏览器的模糊匹配 +
" electbuf.vim相比，它少了对多个buf的批量选择和处理
" mru.vim -> fuzzyfinder.vim:FuzzyFinderMruFile
" favex.vim -> fuzzyfinder.vim:FuzzyFinderFavFile
" selectbuf.vim -> fuzzyfinder.vim:FuzzyFinderBuffer
" NERDTree.vim -> fuzzyfinder.vim:FuzzyFinderFile

" AlignPlugin.vim的一些按键映射
" AlignMaps.vim

" 按照一定格式对齐文本
" AlignPlugin.vim

" 列出当前打开的buffer,可以很容易的切换到和删除选定的buffer,必备插件之一
" bufexplorer.vim

" 一些插件用到的一些库函数
" cecutil.vim

" cscope的vim插件,提供快捷键操纵cscope,好东东,如果你在用cscope的话
" Bundle 'cscope_maps.vim'

" 添加doxygen注释
" DoxygenToolkit.vim
" plugin - DoxygenToolkit.vim  由注释生成文档，并且能够快速生成函数标准注释
"-----------------------------------------------------------------
let g:DoxygenToolkit_authorName="Asins - asinsimple AT gmail DOT com"
let g:DoxygenToolkit_briefTag_funcName="yes"
map <leader>da :DoxAuthor<CR>
map <leader>df :Dox<CR>
map <leader>db :DoxBlock<CR>
map <leader>dc a /*  */<LEFT><LEFT><LEFT>

" FavEx : Favorite file and directory explorer ,可以添加目录和文件到收藏夹，可以把经常编辑的文件添加到收藏夹来，在文件打开以后，\ff新增文件到收藏夹，\fd新增目录到收藏夹
" favex.vim

" Commentary: 快速注释。
" Bundle 'tpope/vim-commentary'

" fencview.vim
" mbbill的编码识别插件

" great for latex
" latex-suite

" Switch very quickly between your most recently used buffers
" LustyJuggler

" 扩展了vim的%功能,让%可以匹配的,不再仅仅是括号,支持多种语言.必备插件之一
" matchit.vim
" Bundle 'matchit.zip'
" plugin - matchit.vim   对%命令进行扩展使得能在嵌套标签和语句之间跳转
" % 正向匹配      g% 反向匹配
" [% 定位块首     ]% 定位块尾

" Address, 给vim增加MRU功能,也就是保留最近打开的文件记录,:MRU打开,q退出,很方便,有过一个支持菜单的类似的插件 不过对于我这样的不用菜单的用户,还是这个命令行的好用一点,因为经常使用,所以我映射到了F2
" Mru

" 同时选择多个区域
" multiselect.vim

" array操作库函数，multiselect依赖它
" multvals.vim

" netrw清理工具，经常升级netrw的话，用来删除老版本
" netrwclean.vim

" 给选中的文字加上引号,支持( { [ < ' " `,选中后,\加上你想要添加的符号,比如选中abc后,\(,得到(abc)
" Bundle 'parenquote'
" Bundle 'jiangmiao/auto-pairs'

" 快速打开关闭quickfix window
" qfixtoggle.vim

" Very small, clean but quick and powerful buffer manager. c.
" qbuf

" 提供快速的buffer选择
" selectbuf.vim

" 画图
" sketch.vim

" 扩展了vim的abbr缩写功能,支持占位符,支持变量替换.
" snippetEmu.vim

" 功能强大的缩写扩展，vim版的TextMate
" snippetsEmu.vim

" 给vim整合了cvs/subversion功能,不用离开vim环境也能执行常用的cvs/subversion操作.
" vcscommand.vim

" vimincr.vim的公共接口
" visincrPlugin.vim

" 给vim增加生成递增或者递减数列的功能,支持十进制,十六进制,日期,星期等,功能强大灵活
" visincr提供生成数列的功能+ :SO % 后visincr.vba.gz会消失变成visincr.vba
" visincr.vim

" 可以对选中的文本块执行ex操作,尤其是visual block模式下,vim自己是不支持的.选中后,:B 加上ex命令
" vis.vim

" 单词完成，没用它
" word_complete.vim

" 类似emacs的king ring,给vim的yank也增加缓冲,vim本身只缓冲删除的字符串,不缓冲yank的内容
" yankring.vim
"-----------------------------------------------------------------
"unused
" 查看和自动识别文件的编码格式
" Bundle 'mbbill/fencview'
" vim的wiki
" viki.vim
" 在vim在模拟Terminal
" Bundle 'rosenfeld/conque-term'
" 将语法高亮转成 BBS 上的彩色
" toansi.vim
" 让大文件打开快一点
" LargeFile.vim
" 给vim增加url的识别功能,但是功能远不只是支持url,还有更多,详情见utl的帮.
" utl.vim
" 自制的工程管理插件
" project.vim
" 在vim里查看man
" manpageview.vim

"-----------------------------------------------------------------
"python 插件
"if v:version < 704
"    Bundle 'Pydiction'
"    Bundle 'Python-mode-klen'
"endif
" best for python
" python_calltips
"   pydiction       补全提示+
let g:pydiction_location = '.vim/pydiction-1.2/complete-dict'
"   pythoncomplete  vim自带的python补全提示
"   VimPdb          调试Python程序+
" Bundle 'pyflakes' "Python代码检查+
" Bundle 'pytest'
"-----------------------------------------------------------------

" Bundle 'jsfaint/gen_tags.vim'
" Bundle 'PasteBin.vim'
" Bundle 'tohtml.vim'
" Bundle 'matchparen.vim'
" Bundle 'xml.vim'
" Bundle 'vimwiki.vim'
" Bundle 'zipPlugin.vim'
" Bundle 'vimballPlugin.vim'
"-----------------------------------------------------------------


endif
"===================================================

" wgao add
nmap  <F4> :!mk<cr>
nmap  <S-F4> :!mktag &<cr>
nmap <leader>cb :g/^\s*$/d<cr>

"定义快捷键的前缀，即<Leader>
 let mapleader=";"

" No sound on errors
set noerrorbells            " 关闭错误信息响铃
set novisualbell            " 关闭使用可视响铃代替呼叫
set t_vb=                   " 置空错误铃声的终端代码

" vim 自身命令行模式智能补全
 set wildmenu

"1.任意方式对齐
"2.自动排版
"3.注释代码
"4.添加自定义注释
"5.

" wgao add OK

"支持代码折叠
"set foldlevel=3
"set foldenable      " 允许折叠
"setlocal foldlevel=1        " 设置折叠层数为
"set foldclose=all           " 设置为自动关闭折叠
set foldmethod=syntax " 用语法高亮来定义折叠
"set foldmethod=manual   " 手动折叠
"set foldmethod=marker
"set foldmethod=indent
set foldlevel=100 " 启动vim时不要自动折叠代码
set foldcolumn=1 " 设置折叠区域的宽度
": exec 'cd ~/' . fnameescape('/.vim')
" 用<F3>键来开关折叠
nmap <F3> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

set   wildignore=*.bak,*.o,*.e,*~

" Fast saving
nmap <leader>w :w!<cr>
nmap <leader>qq :qa!<cr>

" Fast editing of the .vimrc
map <leader>e :e! ~/.vimrc<cr>

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

"代码补全
set completeopt=preview,menu
set completeopt=longest,menu
"set nobackup                " 覆盖文件时不备份
set backupcopy=yes          " 设置备份时的行为为覆盖
set autochdir               " 自动切换当前目录为当前文件所在的目录
"新建标签
map <M-F2> :tabnew<CR>
"列出当前目录文件
map <M-F3> :tabnew .<CR>


set fillchars=vert:\ ,stl:\ " 在被分割的窗口间显示空白，便于阅读,stlnc:\(加了这个wm分割兰有\\\\\\\\\\\\\)
"To hex modle
let s:hexModle = "N"
function! ToHexModle()
    if s:hexModle == "Y"
        %!xxd -r
        let s:hexModle = "N"
    else
        %!xxd
        let s:hexModle = "Y"
    endif
endfunction
"map <leader>h :call ToHexModle()<cr>

" 不要生成swap文件，当buffer被丢弃的时候隐藏它
set nobackup
set nowb
set noswapfile
set bufhidden=hide

set history=300 " history文件中需要记录的行数

"窗口分割时,进行切换的按键热键需要连接两次,比如从下方窗口移动
"光标到上方窗口,需要<c-w><c-w>k,非常麻烦,现在重映射为<c-k>,切换的
"时候会变得非常方便.
" Switching between buffers.
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
inoremap <C-h> <Esc><C-W>h
inoremap <C-j> <Esc><C-W>j
inoremap <C-k> <Esc><C-W>k
inoremap <C-l> <Esc><C-W>l

" 带有如下符号的单词不要被换行分割
"set iskeyword+=_,$,@,%,#,-

" 映射全选+复制 ctrl+a
" map <C-A> ggVGY
" map! <C-A> <Esc>ggVGY
"
" 命令行（在状态行下）的高度，默认为1
set cmdheight=1

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"共享剪贴板
set clipboard+=unnamed
map <F12> gg=G
" 在行和段开始处使用制表符
set smarttab


set guifont=Courier_New:h10:cANSI   " 设置字体

" 移除高亮
" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax
" 启动 vim 时关闭折叠代码
set nofoldenable

" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)

    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag . '| update'
endfunction

" 不确认、非整词
nnoremap <Leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 不确认、整词
nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap <Leader>rcw :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

" 全屏开/关快捷键
" map <silent> <F11> :call ToggleFullscreen()<CR>
" 启动 vim 时自动全屏
" autocmd VimEnter * call ToggleFullscreen()
" 将外部命令 wmctrl 控制窗口最大化的命令行参数封装成一个 vim 的函数
fun! ToggleFullscreen()
  call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")
endf

" 禁止光标闪烁
set gcr=a:block-blinkon0
set matchtime=5 " 匹配括号高亮的时间（单位是十分之一秒）
