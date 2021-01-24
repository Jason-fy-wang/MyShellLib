# 查看版本号
npm -v

# 安装webpack
npm install webpack -g

# vue 脚手架
npm install vue-cli -g

# 卸载
npm uninstall -g @vue/cli  # 下载3版本的脚手架

yarn add sass-loader node-sass -dev

# 设置淘宝镜像
npm install -g cnpm --registry=https://registry.npm.taobao.org
npm config set registry https://registry.npm.taobao.org
npm config get registry

# 查看配置
npm config ls
npm config ls -l  # 查看所有默认的配置
npm cache clear --force

# 设置下载的缓存的位置
npm config set cache E:\nodeReps\npm-cache
npm config set prefix E:\nodeReps\node-global


# 安装yarn
cnpm install yarn -g -verbose
cnpm install font-awesome --save
cnpm install sass-loader node-sass --save
cnpm install axios --save
cnpm install element-ui --save
import 'element-ui/lib/theme-chalk/index.css'

# 设置yarn的镜像
yarn config set registry https://registry.npm.taobao.org

# npm  yarn 命令对比
npm install                 =>      yarn install
npm install --save package  =>      yarn add package
npm install --save-dev package =>   yarn add package --dev
npm install --global package =>     yarn global add package
npm uninstall --save package =>     yarn remove package
npm uninstall --save-dev package => yarn remove package 

# 使用vue脚手架创建项目
vue-init webpack mango-ui

# 打包
npm run build

# font-awesome
npm install font-awesome --save
import 'font-awesome/css/font-awesome.min.css';

# 
rimraf node-modules

cnpm install vue-cookie  --save

#### 安装js执行引擎
# 安装eshost
npm install -g eshost-cli

# 安装jsvu
npm install -g jsvu
# 运行jsvu 以安装各个引擎
jsvu
# 指定jsvu管理的引擎(可指定 Chakra, JavaScriptCore,SpiderMonkey,v8,GraalJS,Hermes,QuickJS,XS)
jsvu --engine=chakra,javascriptcore
# 指定jsvu安装的具体版本
jsvu Chakra@1.11..6
# 以指定的引擎来运行代码(可对引擎设定名字,通配符, 并用-n/-g/-tags来指定)
eshost -h Chakra test.js

# macos 将JavaScript引擎(chakra) 托管给eshost
eshost --add 'Chakra' ch ~/.jsvu/chakra
# windows
eshost --add 'Chakra' ch "%USERPROFILE%\.jsvu\chakra.cmd"
# 测试
eshost -tse '1+2'
eshost -tsx 'print (1+2)'
eshost -ts test.js
