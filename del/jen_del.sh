#!/bin/bash
USERNAME="xxx"
PASSWORD="xxxxxx"
POSTURL="http://1.1.1.1:8080/role-strategy/strategy/deleteSid"
NULL=
user_name=$1
if [ "$user_name" != "$NULL" ]
then

curl -u $USERNAME:$PASSWORD -X POST $POSTURL \
-H 'Content-Type:application/x-www-form-urlencoded;charset=utf-8' \
-d 'type=globalRoles' \
-d "sid=$1" \

curl -u $USERNAME:$PASSWORD -X POST $POSTURL \
-H 'Content-Type:application/x-www-form-urlencoded;charset=utf-8' \
-d 'type=projectRoles' \
-d "sid=$1" \

else
echo "values is null!! "
exit 200
fi
