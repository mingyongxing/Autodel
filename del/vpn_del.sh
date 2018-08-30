#!/bin/bash
vpncmd="/root/scripts/autodel/SE-VPN_server/vpncmd"
server="1.1.1.1"
adminhub="my-admin-hub"
password="xxxxxx"
username="$1"
NULL=
if [ "$username" != "$NULL" ]
then
$vpncmd /SERVER $server /adminhub:$adminhub /PASSWORD:$password /CMD Userdelete $username
else
echo "values is null !!!"
exit 200
fi

