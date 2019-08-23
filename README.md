[![Docker Image](https://img.shields.io/badge/docker%20image-available-green.svg)](https://cloud.docker.com/u/loodp/repository/docker/loodp/svn-server)

## 描述
本来想弄个svn仓库迁移，之前是docker+centos+apache+svn，非常麻烦，故学习了下，大开眼界。本hub主要为了记录下方便之后使用，需要的同学自行使用，有问题共同探讨哈。顺便一提，github+dockerhub确实很好用，实时上传+building。
基于Alpine 3.7，轻量级，只有几十M，内置httpd+svnserve，可以在容器启动同时自启，没有其它的冗余，比较基础，可以根据自身条件进行调整，个人感觉比较适合个人使用。

## 运行命令
```shell
# docker run -it -d --name=svn-server -p 80:80 -p 3690:3690 -v PATH:/home/svn -v PATH:/home/conf -v PATH:/home/tools loodp/svn-server
```
基于docker构建，设想环境在主机使用nginx指向```localhost:80```，故不带443端口配置，需要的同学自行增加。运行后访问```http://localhost/svn```查看对应svn版本库，也可使用```svn://localhost:3690```，不需要可不开docker的3690端口。

## 新增用户
基于WebDev协议设置账户密码：
```shell
# docker exec -t svn-server htpasswd -b /etc/subversion/passwd <username> <password>
```

**本项目不带svnAdmin，需要的同学可以去原项目中复制**

需要的话可自行配置dav_svn.conf，[参考](https://svn.apache.org/repos/asf/subversion/trunk/subversion/mod_authz_svn/INSTALL)

## run.sh

本人shell小白，sh脚本编写比较烂，脚本简单实现了svnserve、httpd的开机自启，subversion-access-control文件的软链，有需要的同学自行调整下

## 版本信息
```shell
/ # httpd -v
Server version: Apache/2.4.39 (Unix)
Server built:   Apr  3 2019 15:53:25

/ # svnadmin --version
svnadmin, version 1.9.12 (r1863368)
   compiled Aug  6 2019, 10:06:55 on x86_64-alpine-linux-musl

Copyright (C) 2019 The Apache Software Foundation.
This software consists of contributions made by many people;
see the NOTICE file for more information.
Subversion is open source software, see http://subversion.apache.org/

The following repository back-end (FS) modules are available:

* fs_fs : Module for working with a plain file (FSFS) repository.
* fs_x : Module for working with an experimental (FSX) repository.
* fs_base : Module for working with a Berkeley DB repository.

```

## VOLUME
简单提下，```/home/svn```是在参考仓库中就带的，但是考虑容器内编辑authz文件会比较费劲，所以在run.sh中加了软链，在执行```docker run```时可以加上```-v <hostpath>:/home/conf```，此处会将subversion-access-control文件copy到目录内，可以在主机内编辑，并且同时在容器内生效。


主要参考项目：

https://github.com/elleFlorio/svn-docker

https://github.com/iaean/docker-subversion

欢迎各位指正批评