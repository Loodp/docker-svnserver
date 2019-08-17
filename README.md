构建docker-svn服务

需求

1、http协议

2、映射到本地的仓库目录

3、使用钩子

4、不使用svnadmin，通过exec配置

5、软链subversion-access-control 至 /home/conf/ 并调整 VOLUME /home

在 https://github.com/elleFlorio/svn-docker 基础上构建dockerfile

目前测试阶段，暂请勿参考