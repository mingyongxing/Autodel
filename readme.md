#### about
* removeuser.sh 是主脚本，每天从库里取出所有用户进行比对，取出离职用户
* del 文件夹中的四个脚本是用来删除权限用的
* 另外取出所有用户存到库里的脚本不是我写的，所以没有共享

#### 如何执行删除？
* confluence 请求API删除
* Jenkins 请求插件的API删除
* svn 直接注释掉用户
* softether vpn 有自己的命令行工具
