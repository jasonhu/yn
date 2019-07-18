# 使用yn-mk-editor容器来编写markdown

```sh
# 进入需要编辑md文件的工作目录
# 一般该目录会是一个git代码仓库
$ cd /xxx/mydata 
# 获取最新的镜像包
$ docker pull jasonhu2019/yn-md-editor
# 运行容器，在后台运行，停止时候删除
# 将当前目录映射到容器，以进行md文件编辑
# 将端口映射到本地的3001
$ docker run --rm -d --name yn-md-editor -v $(pwd):/data/app/data -p 3001:3000 jasonhu2019/yn-md-editor
# 停止容器，删除容器
$ docker stop yn-md-editor
$ docker rm rm-md-editor
```

容器运行后，打开浏览器，访问 http://localhost:3001 ，就可以看到markdown编辑界面。

- 左边是目录和文件列表
- 中间是markdown编辑区域
- 右边是效果预览页面

# 将系统打包为docker镜像并发布

## 镜像打包
在根目录下，准备好[Dockerfile](Dockerfile)文件

```sh
$ docker build -t yn-md-editor:1.0 .
```

## 发布镜像
```sh
# 打上用户tag，准备发布
$ docker tag yn-md-editor:1.0 jasonhu2019/yn-md-editor 
# 发布镜像
$ docker login
$ docker push jasonhu2019/yn-md-editor
```

# 使用docker容器来调试

## 编译，运行和调试后端，前端
```sh
# 启用一个node容器，将本地代码映射到容器 /data/app
# 将3000端口映射到本地，将8080端口映射到本地
# 将容器命名为node-alpine
# 进入到容器shell中
$ docker run -it --rm --name node-alpine -v $(pwd):/data/app -p 3000:3000 -p 8080:8080 node:alpine /bin/sh

# 连接到调试容器，开启另外一个console终端，以可以同时进行多个进程执行
$ docker exec -it node-alpine /bin/sh

# 后台进程启动，在容器中运行
$ cd /data/app/backend
$ yarn
$ node main.js # 启动，在3000端口监听

# 前台进程启动，在容器中运行
$ cd /data/app/frontend
$ yarn
$ yarn run serve # 以调试方式，运行前端程序，在8080中监听
# 注意，前端的vue.config.js，将/api,/ws代理给了后端的3000端口
```

## 访问8080端口

打开浏览器，访问http://localhost:8080，查看效果
> 该调试访问时直接访问前端的端口8080，正式发布的时候，是以node服务的3000为主服务端口

