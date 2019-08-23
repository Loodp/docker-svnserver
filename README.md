# 构建docker下 svn+apache 服务

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


主要参考项目：

https://github.com/elleFlorio/svn-docker

https://github.com/iaean/docker-subversion

欢迎各位指正批评