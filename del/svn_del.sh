#!/bin/bash
CODEAUTH="/data/svn/web/conf/authz"
CODEPASSWD="/data/svn/web/conf/passwd"
DOCAUTH="/data/svn/doc/conf/authz"
DOCPASSWD="/data/svn/doc/conf/passwd"
user_name=$1
NULL=
KEY="/home/svn/svn"
codesvn="1.1.1.1"
docsvn="1.1.1.2"
if [ "$user_name" != "$NULL" ]
then
ssh  root@$docsvn > /dev/null 2>&1 << eeooff
sed -i "s/^$user_name/#$user_name/g" $DOCPASSWD
sed -i "s/,$user_name//g" $DOCAUTH
sed -i "s/=$user_name,/=/g" $DOCAUTH
eeooff
ssh  root@$codesvn > /dev/null 2>&1 << eeooff
sed -i "s/^$user_name/#$user_name/g" $CODEPASSWD
sed -i "s/,$user_name//g" $CODEAUTH
sed -i "s/=$user_name,/=/g" $CODEAUTH
eeooff
else
echo value is null script will exit!!
fi


