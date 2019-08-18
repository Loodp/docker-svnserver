构建docker下 svn+apache 服务

参考 https://github.com/elleFlorio/svn-docker 

需求

1、http协议

2、映射到本地的仓库目录

3、使用钩子

4、不使用svnadmin，通过exec配置

5、软链subversion-access-control 至 /home/conf/ 并调整 VOLUME /home

```shell
# docker run -it -d --name=svn-server -p 9991:80 -p 9992:443 -p 9993:3690 -v /home/docker/svn:/home/svn -v /home/docker/conf:/home/conf -v /home/docker/tools:/home/tools loodp/svn-server:latest
```

conf：保存配置文件 

目前测试阶段，暂请勿参考 