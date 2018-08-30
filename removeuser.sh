#!/bin/bash
export LANG=zh_CN.UTF-8
date=`date +"%Y-%m-%d %H:%M:%S"`
#dir
home="/xxx/scripts/autodel"
log="$home/log/autodel.log"
binlog="$home/log/binlog.log"
svnlist="$home/userlist/svnlist"
vpnlist="$home/userlist/vpnlist"
jenlist="$home/userlist/jenlist"
conflist="$home/userlist/conflist"
conf_del="$home/del/conf_del.py"
jen_del="$home/del/jen_del.sh"
svn_del="$home/del/svn_del.sh"
vpn_del="$home/del/vpn_del.sh"
alluser="$home/alluser"
userlist="$alluser/userlist"
userlistold="$alluser/userlistold"
#python
python3="/usr/local/python37/bin/python3"
python="/bin/python"
#mysql
mysql="/usr/local/mysql/bin/mysql"
u="xxx"
p="xxx"
h="xxx"
d="autodel"
#find departrue man
#比对昨日和今日的用户列表，今日的列表userlist中比昨日列表userlistold的少的话，说明昨日有用户的钉钉被删除（离职）
function depart {
grep -vwf $userlist $userlistold
}
#这个函数是用来防止请求失败 导致把所有用户都当成了离职用户删除的一道保险  还有就是有可能一个部门的员工调整到分公司 一次最多删除8个
function mailto {
echo "depart man more than 8 " | mail -s "depart man more than 8" mingyongxing@666.com
}

function mailerr {
echo "get all user list faild " | mail -s "get all user list faild" mingyongxing@666.com
}

#update system user list
#更新这些后台系统的用户，落地成文件 后面要对比离职的用户有没有开通这些权限
$mysql -u$u -p$p -h$h -e "use autodel ; select * from confluence;" | grep -v confluence | awk -F "|" '{print $1}' > $conflist
echo "$date get conflist successful.">> $log
$mysql  -u$u -p$p -h$h -e "use autodel ; select * from jenkins;" | grep -v jenkins | awk -F "|" '{print $1}' > $jenlist
echo "$date get jenlist successful." >> $log
$mysql  -u$u -p$p -h$h -e "use autodel ; select * from svn;" | grep -v svn | awk -F "|" '{print $1}' > $svnlist
echo "$date get svnlist successful." >> $log
$mysql  -u$u -p$p -h$h -e "use autodel ; select * from vpn;" | grep -v vpn | awk -F "|" '{print $1}' > $vpnlist
echo "$date get vpnlist successful." >> $log
# get dingtalk all user
# 我有一个脚本是单独跑的 每日取出钉钉所有用户 存到库里
#这是取出最新的用户列表落地成文件方便对比
$mysql  -u$u -p$p -h$h -D$d -e "select * from alluser;"  | awk '{print $3}' | sort | uniq -c | awk  '{print $2}' > $userlist

if [ $? = 0 ]
then
echo "$date get alluser successful." >> $log
#这个变量是取出有多人用户离职
#就如上所说，如果“离职”的人太多 大于8人 会邮件报警 手动改脚本删除
makesure=`grep -vwf $userlist $userlistold | wc -l`

else
echo "$date fail to get userlist." >> $log
#这里如果取用户落地成文件失败了 也会发邮件报警的 
mailerr
exit 200
fi
#取出离职用户
depart
if [ $? -eq 0 ]
 then 
	if [ $makesure -lt 8 ]
	then
#这里的操作都是比对那四个后台系统的用户，用户是我提前存到库里的，如果离职的成员没有开通这个权限，也就没必要执行删除操作了
  for i in `depart` 
  do
#比对离职成员是否有该权限，后面类似不注释了
  grep $i $conflist
	if [ $? = 0 ]
	 then
	 $python $conf_del $i
	 echo "$date" >> $binlog
         $mysql  -u$u -p$p -h$h -e "use autodel ; delete from  confluence  where confluence = \"$i\";" >> $binlog 2>$1
         echo "$date user $i confluence deleted." >> $log
	 else
	 echo "$date user $i confluence not open." >> $log
        fi
  grep $i $jenlist
        if [ $? = 0 ]
         then
         /bin/sh $jen_del $i
         $mysql -u$u -p$p -h$h -e "use autodel ; delete from  jenkins  where jenkins = \"$i\";" >> $binlog 2>$1
	 echo "$date" >> $binlog
          echo "$date user $i jenkins deleted." >> $log
         else
         echo "$date user $i jenkins not open." >> $log
        fi
  grep $i $svnlist
        if [ $? = 0 ]
         then
         /bin/sh $svn_del $i
         $mysql -u$u -p$p -h$h -e "use autodel ; delete from  svn  where svn = \"$i\";" >> $binlog 2>$1
	 echo "$date" >> $binlog
	 echo "$date user $i svn deleted." >> $log
         else
         echo "$date user $i svn not open." >> $log
        fi
  grep $i $vpnlist
        if [ $? = 0 ]
         then
         /bin/sh $vpn_del $i
         $mysql -u$u -p$p -h$h -e "use autodel ; delete from  vpn  where svn = \"$i\";" >> $binlog 2>$1
	 echo "$date" >> $binlog
         echo "$date user $i vpn deleted." >> $log
         else
         echo "$date user $i vpn not open." >> $log
        fi
done
#更新，要把删除过的用户更新到userlistold文件中，不然下次比对又会执行删除操作
cat $userlist > $userlistold
echo "$date update userlist successful." >> $log
	else
	echo "$date depart man more than 8 " >> $log
	mailto
	fi
else
echo "$date no depart user." >> $log
fi


