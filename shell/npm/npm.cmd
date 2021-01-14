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


