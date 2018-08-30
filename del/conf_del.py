#!/usr/bin/python
# -*- coding: utf-8 -*-
# Confluence XML RPC Fun!
#所有方法
#https://developer.atlassian.com/server/confluence/remote-confluence-methods/
#
import os
import sys
import getpass
import xmlrpclib
from xmlrpclib import Server
server = Server("http://1.1.1.1:8090/rpc/xmlrpc")
token = server.confluence1.login("admin", "xxxx")
username = sys.argv[1]
#删除这个用户
#server.confluence1.removeUser(token, username)
#禁用这个用户
server.confluence1.deactivateUser(token, username)
